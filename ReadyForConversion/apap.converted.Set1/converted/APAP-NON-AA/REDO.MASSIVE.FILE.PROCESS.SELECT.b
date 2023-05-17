SUBROUTINE REDO.MASSIVE.FILE.PROCESS.SELECT
*------------------------------------------------------------
* Description: This is single threaded routine to process the
* massive rate file.

* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh         Massive rate - B.16  INITIAL CREATION
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.MASSIVE.FILE.PATH
    $INSERT I_REDO.MASSIVE.FILE.PROCESS.COMMON

    GOSUB PROCESS

RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------
    Y.LIST.OF.FILES = ''
    Y.FILE.PATH = R.FILE.DETAILS<MASS.FILE.UNPROCESSED.PATH>
    SEL.CMD = 'SELECT ':Y.FILE.PATH
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE SEL.NOR
        Y.FILE = SEL.LIST<Y.VAR1>
        Y.DATE = FIELD(Y.FILE,'_',2)
        IF Y.DATE GE R.DATES(EB.DAT.LAST.WORKING.DAY) AND Y.DATE LT TODAY THEN
            Y.LIST.OF.FILES<-1>=Y.FILE
        END
        Y.VAR1 += 1
    REPEAT

* PACS00761324 START
* -----------------------------------------------------------
    Y.LIST.OF.ARR = ''
    Y.FILENAME = ''
    ICOUNT = ''
    JCCOUNT = ''
    J.TMP.RECORD = ''
    J.CLEAR.COMMAND = ''
    J.NUMELEM1 = ''
    J.NUMELEM2 = ''

*Loop for each file to unite in one array the arrangements to be processed
    J.NUMELEM1 = DCOUNT (Y.LIST.OF.FILES,@FM)
    CALL OCOMO("J.NUMELEM1 = ": J.NUMELEM1)
    FOR ICOUNT = 1 TO J.NUMELEM1
        Y.FILENAME = Y.LIST.OF.FILES<ICOUNT>
        CALL OCOMO("Loop ":ICOUNT:" --> Y.FILENAME = ":Y.FILENAME)
* OPEN FILE PATH
        OPEN Y.FILE.PATH TO F.FILE.PATH ELSE
            CALL OCOMO(Y.FILENAME:" File not available in path ":Y.FILE.PATH)
            RETURN
        END
* OPEN FILE
        READ Y.REC.ARRAY FROM F.FILE.PATH,Y.FILENAME ELSE
            CALL OCOMO("File could not be read")
            RETURN
        END
        CHANGE '"' TO " " IN Y.REC.ARRAY
        Y.REC.ARR = TRIM(Y.REC.ARRAY,"","A")
        Y.DOT = CHARX(13)
        CHANGE Y.DOT TO '' IN Y.REC.ARR
* store temp array to Y.LIST.OF.ARR
        J.NUMELEM2 = DCOUNT (Y.REC.ARR,@FM)
        CALL OCOMO("J.NUMELEM2 = ": J.NUMELEM2)
        FOR JCOUNT = 1 TO J.NUMELEM2
            J.TMP.RECORD = Y.REC.ARR<JCOUNT> :",":Y.FILENAME
            Y.LIST.OF.ARR<-1> = J.TMP.RECORD
        NEXT JCOUNT
    NEXT ICOUNT
*  CALL BATCH.BUILD.LIST('',Y.LIST.OF.FILES)
    CALL BATCH.BUILD.LIST('',Y.LIST.OF.ARR)
* -----------------------------------------------------------
* PACS00761324 END

RETURN
END
