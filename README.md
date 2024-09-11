#include <stdio.h>

int main() {
    int n = 31;  // Total width of the pattern (31 columns)
    int m = 6;   // Total height of the pattern (6 rows)

    // Loop through each row
    for (int i = 1; i <= m; i++) {
        // Loop through each column
        for (int j = 1; j <= n; j++) {
            // First and last rows are filled with '*'
            if (i == 1 || i == m) {
                printf("*");
            } else if (j == 1 || j == n) {  // First and last columns are '*'
                printf("*");
            } else {
                // Inner pattern with spaces and '#'
                if ((i == 2 && j == 27) ||  // Second row, 27th column is '#'
                    (i == 3 && (j == 22 || j == 27)) ||  // Third row, 22nd and 27th columns are '#'
                    (i == 4 && j == 6) ||  // Fourth row, 6th column is '#'
                    (i == 5 && (j == 6 || j == 11))) {  // Fifth row, 6th and 11th columns are '#'
                    printf("#");
                } else {
                    printf(" ");  // Otherwise print space
                }
            }
        }
        printf("\n");  // Move to the next line after each row
    }

    return 0;
}
