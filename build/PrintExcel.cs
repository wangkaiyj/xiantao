using System;
using System.Collections.Generic;
using System.Drawing.Printing;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.Win32;
using Excel = Microsoft.Office.Interop.Excel;


namespace RobvanderWoude
{
	class PrintExcel
	{
		static string progver = "1.00";


		static Excel.Application excelapp;
		static Excel.Workbook excelworkbook;


		static int Main( string[] args )
		{
			string file;
			string sheet;
			string rangestart;
			string rangeend;
			string printer = new PrinterSettings( ).PrinterName; // Default Printer
			bool usedefaultprinter = true;

			switch ( args.Length )
			{
				case 2:
					file = args[0];
					sheet = args[1];
					break;
				case 3:
					file = args[0];
					sheet = args[1];
					printer = args[2];
					usedefaultprinter = false;
					break;
				case 4:
					file = args[0];
					sheet = args[1];
					rangestart = args[2];
					rangeend = args[3];
					break;
				case 5:
					file = args[0];
					sheet = args[1];
					rangestart = args[2];
					rangeend = args[3];
					printer = args[4];
					usedefaultprinter = false;
					break;
				default:
					return ShowHelp( );
			}

			// Check if Excel file exists
			if ( !File.Exists( file ) )
			{
				return ShowHelp( "File not found: \"{0}\"", file );
			}

			// Check if printer exists
			bool validprinter = false;
			foreach ( string prn in PrinterSettings.InstalledPrinters )
			{
				if ( prn.ToUpper( ) == printer.ToUpper( ) )
				{
					validprinter = true;
				}
			}
			if ( !validprinter )
			{
				return ShowHelp( "Printer not found: \"{0}\"", printer );
			}

			// Open Excel
			excelapp = new Excel.Application( );
			excelapp.Visible = false;
			excelapp.Visible = true;
			excelworkbook = excelapp.Workbooks.Open( file );

			// Change printer - must be done AFTER opening the excel workbook
			if ( !usedefaultprinter )
			{
				// Format printer string for Excel, e.g. "HPLaserJet on Ne01:"
				string prnspl = Registry.GetValue( @"HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices", printer, null ).ToString( );
				if ( !String.IsNullOrEmpty( prnspl ) )
				{
					if ( prnspl.IndexOf( ',' ) > 0 )
					{
						prnspl = prnspl.Substring( prnspl.IndexOf( ',' ) + 1 );
						if ( !String.IsNullOrEmpty( prnspl ) )
						{
							printer = String.Format( "{0} on {1}", printer, prnspl );
						}
					}
				}
				try
				{
					excelapp.ActivePrinter = printer;
				}
				catch ( Exception e )
				{
					try
					{
						excelworkbook.Close( );
					}
					catch { }
					try
					{
						excelapp.Quit( );
					}
					catch { }
					return ShowHelp( e.Message );
				}
			}

			if ( Regex.IsMatch( sheet, @"^\d+$" ) )
			{
				int index = int.Parse( sheet );
				if ( index <= excelworkbook.Sheets.Count )
				{
					ExcelPrint( index );
				}
				else
				{
					excelworkbook.Close( );
					excelapp.Quit( );
					return ShowHelp( "Sheet index out of bound: {0} (maximum for this workbook: {1})", index.ToString( ), excelworkbook.Sheets.Count.ToString( ) );
				}
			}
			else
			{
				bool validsheetname = true;
				for ( int i = 1; i <= excelworkbook.Sheets.Count; i++ )
				{
					Excel.Worksheet ws = excelworkbook.Worksheets[i];
					if ( ws.Name.ToUpper( ) == sheet.ToUpper( ) )
					{
						validsheetname = true;
					}
				}
				if ( validsheetname )
				{
					ExcelPrint( sheet );
				}
				else
				{
					excelworkbook.Close( );
					excelapp.Quit( );
					return ShowHelp( "No matching worksheet found: \"{0}\"", sheet );
				}
			}

			excelworkbook.Close( );
			excelapp.Quit( );

			return 0;
		}


		static bool ExcelPrint( string tab = "Sheet1", string start = null, string end = null )
		{
			// Print all sheets if "name" is "/ALL"
			if ( tab.ToUpper( ) == "/ALL" )
			{
				bool success = true;
				for ( int i = 1; i <= excelworkbook.Sheets.Count; i++ )
				{
					Excel.Worksheet sheet = excelworkbook.Worksheets[i];
					if ( sheet.Name.ToUpper( ) == tab.ToUpper( ) )
					{
						success = success && ExcelPrint( i, start, end );
					}
				}
				return success;
			}
			else
			{
				// Print sheet with matching name
				for ( int i = 1; i <= excelworkbook.Sheets.Count; i++ )
				{
					Excel.Worksheet sheet = excelworkbook.Worksheets[i];
					if ( sheet.Name.ToUpper( ) == tab.ToUpper( ) )
					{
						return ExcelPrint( i, start, end );
					}
				}
			}
			return false;
		}


		static bool ExcelPrint( int tab = 1, string start = null, string end = null )
		{
			try
			{
				Excel.Worksheet sheet = excelworkbook.Worksheets[tab];
				Excel.Range range;
				if ( String.IsNullOrEmpty( start ) || String.IsNullOrEmpty( end ) )
				{
					range = sheet.UsedRange;
				}
				else
				{
					range = sheet.get_Range( start, end );
				}
				range.PrintOutEx( );
				return true;
			}
			catch ( Exception )
			{
				return false;
			}
		}


		static int ShowHelp( params string[] errmsg )
		{
			/*
			PrintExcel.exe,  Version 1.00
			Command line Excel sheet printing tool
			
			Usage:   PrintExcel.exe  file  sheet  [ firstcell  lastcell ]  [ printer ]
			
			Where:   file         is the Excel file to be printed
			         sheet        is the sheet name or (1 based) index to be printed
			         firstcell    is the first cell of the range to be printed
			         lastcell     is the last cell of the range to be printed
			         printer      is the printer name
			
			Notes:   Instead of a sheet name/index, /ALL can be used to print all sheets.
			         The default range to be printed is the sheet's "used range".
			         If no printer is specified, the default printer will be used.
			         Return code is 1 if an error is detected, otherwise 0.
			
			Example: PRINTEXCEL  sales.xls  Sheet1  A1  F45  "LaserJet Sales 1st Floor"
			
			Written by Rob van der Woude
			http://www.robvanderwoude.com
			*/


			if ( errmsg.Length > 0 )
			{
				List<string> errargs = new List<string>( errmsg );
				errargs.RemoveAt( 0 );
				Console.Error.WriteLine( );
				Console.ForegroundColor = ConsoleColor.Red;
				Console.Error.Write( "ERROR:\t" );
				Console.ForegroundColor = ConsoleColor.White;
				Console.Error.WriteLine( errmsg[0], errargs.ToArray( ) );
				Console.ResetColor( );
			}

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "PrintExcel.exe,  Version {0}", progver );

			Console.Error.WriteLine( "Command line Excel sheet printing tool" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Usage:   " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "PrintExcel.exe  file  sheet  [ firstcell  lastcell ]  [ printer ]" );
			Console.ResetColor( );

			Console.Error.WriteLine( );

			Console.Error.Write( "Where:   " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "file" );
			Console.ResetColor( );
			Console.Error.WriteLine( "         is the Excel file to be printed" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "         sheet" );
			Console.ResetColor( );
			Console.Error.WriteLine( "        is the sheet name or (1 based) index to be printed" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "         firstcell" );
			Console.ResetColor( );
			Console.Error.WriteLine( "    is the first cell of the range to be printed" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "         lastcell" );
			Console.ResetColor( );
			Console.Error.WriteLine( "     is the last cell of the range to be printed" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "         printer" );
			Console.ResetColor( );
			Console.Error.WriteLine( "      is the printer name" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Notes:   Instead of a sheet name/index, " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "/ALL" );
			Console.ResetColor( );
			Console.Error.WriteLine( " can be used to print all sheets." );

			Console.Error.WriteLine( "         The default range to be printed is the sheet's \"used range\"." );

			Console.Error.WriteLine( "         If no printer is specified, the default printer will be used." );

			Console.Error.WriteLine( "         Return code is 1 if an error is detected, otherwise 0." );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Example: PRINTEXCEL  sales.xls  Sheet1  A1  F45  \"LaserJet Sales 1st Floor\"" );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Written by Rob van der Woude" );

			Console.Error.WriteLine( "http://www.robvanderwoude.com" );


			return 1;
		}
	}
}
