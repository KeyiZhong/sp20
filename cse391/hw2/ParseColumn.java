import java.util.Scanner;

// This program takes a column index (1-based) as a command-line argument, reads a CSV file
// containing a header from stdin, and outputs the selected column to stdout.  
public class ParseColumn {
    public static void main(String[] args) {
        if (args.length < 1) {
            usage();
            return;
        }

        int columnIndex;
        try {
            columnIndex = Integer.parseInt(args[0]) - 1;
        } catch (NumberFormatException e) {
            usage();
            return;
        }

        Scanner input = new Scanner(System.in);
        input.useDelimiter("\n");

        if (input.hasNextLine()) {
            int lineCount = 0;
            while (input.hasNextLine()) {
                lineCount++;
                String line = input.nextLine();
                String[] columns = line.split(",");
                if (columns.length > columnIndex) {
                    System.out.println(columns[columnIndex]);
                } else {
                    throw new IndexOutOfBoundsException("Invalid column index " + (columnIndex + 1) + " for input on line " + lineCount + " (1-indexed)");

                } 
            }
        }

    }
    
    // Prints out the correct usage of this java program.
    public static void usage() {
        System.err.println("Usage: java ParseColumn <column-index>");
        System.err.println("    A 1-based index for the desired column is required");
    }
}
