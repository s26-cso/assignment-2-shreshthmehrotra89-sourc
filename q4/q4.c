#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[6];  
    int num1, num2;

    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
        
        char libname[20];
        snprintf(libname, sizeof(libname), "lib%s.so", op);

        
        void *handle = dlopen(libname, RTLD_LAZY);
        if (!handle) {
            fprintf(stderr, "Error loading library %s: %s\n", libname, dlerror());
            return 1;
        }

        
        dlerror();

        
        typedef int (*op_func_t)(int, int);
        op_func_t func = (op_func_t) dlsym(handle, op);

        char *err = dlerror();
        if (err) {
            fprintf(stderr, "Error finding symbol %s: %s\n", op, err);
            dlclose(handle);
            return 1;
        }

        
        int result = func(num1, num2);
        printf("%d\n", result);

        
        dlclose(handle);
    }

    return 0;
}
