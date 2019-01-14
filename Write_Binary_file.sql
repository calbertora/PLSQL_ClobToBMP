PROCEDURE Write_Binary_file
(
    isbDirectory    in varchar2,
    isbFileName     in varchar2,
    isbFileB64      in clob
)
IS

    rwBuffer  raw(16384);
    biAmt     binary_integer := 16384;
    iPos      integer := 1;
    flFile    utl_file.file_type;

    l_step  PLS_INTEGER := 12000;

BEGIN

    -- open the output file --
    flFile := utl_file.fopen( isbDirectory, isbFileName, 'W', 32764 ) ;

    -- write the file --
    LOOP
        -- read the chunks --
        Dbms_Lob.READ (utl_raw.cast_to_raw(isbFileB64), biAmt, iPos, rwBuffer);

        -- write the chunks --
        Utl_File.Put_Raw(flFile, UTL_ENCODE.BASE64_DECODE(rwBuffer));
        iPos := iPos + biAmt;
    END LOOP;

    -- close the file --
    Utl_File.Fclose(flFile);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        utl_file.fclose(flFile);
    WHEN OTHERS THEN
        dbms_output.put_Line(sqlerrm);
        raise;
END Write_Binary_file
