SUBROUTINE REDO.GL.H.EXTRACT.PARAMETER.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.H.EXTRACT.PARAMETER.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a .VALIDATE routine for the template REDO.GL.H.EXTRACT.PARAMETER
*Linked With       : Template REDO.GL.H.EXTRACT.PARAMETER
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 21 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 03 Jun 2011       Pradeep S            PACS00072689                  Seperate GIT routine for PL
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.RE.STAT.REPORT.HEAD
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    IF V$FUNCTION NE 'I' THEN
        RETURN
    END

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE  = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.RE.STAT.REPORT.HEAD = 'F.RE.STAT.REPORT.HEAD'
    F.RE.STAT.REPORT.HEAD  = ''
    CALL OPF(FN.RE.STAT.REPORT.HEAD,F.RE.STAT.REPORT.HEAD)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    AF = SAP.EP.EXTRACT.NAME
    CALL DUP

    Y.REPORT.COUNT = DCOUNT(R.NEW(SAP.EP.REPORT.NAME),@VM)
    Y.REPORT.INIT = 1

    LOOP
    WHILE Y.REPORT.INIT LE Y.REPORT.COUNT
        Y.SREPORT.INIT=1
        Y.SREPORT.COUNT=DCOUNT(R.NEW(SAP.EP.REPORT.NAME)<1,Y.REPORT.INIT>,@SM)
        LOOP
        WHILE Y.SREPORT.INIT LE Y.SREPORT.COUNT
            GOSUB CHECK.REPORT.NAME
            GOSUB CHECK.GL.IND.DESCRIPTION
            GOSUB CHECK.EXTRACT.ARCH.PATH
            GOSUB CHECK.EXTRACT.TYPE
            Y.SREPORT.INIT +=1
        REPEAT
        Y.REPORT.INIT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
CHECK.REPORT.NAME:
******************
* In this para of the code, the report name is check with COLUMN TYPE as DTMOV or CRMOV

    RE.STAT.REPORT.HEAD.ID = R.NEW(SAP.EP.REPORT.NAME)<1,Y.REPORT.INIT,Y.SREPORT.INIT>
    GOSUB READ.RE.STAT.REPORT.HEAD

    Y.COLUMN.FOUND = ''

    LOCATE 'DTMOV' IN R.RE.STAT.REPORT.HEAD<RE.SRH.COLUMN.TYPE,1> SETTING Y.DTMOV.POS THEN
        Y.COLUMN.FOUND = 1
    END
    LOCATE 'CRMOV' IN R.RE.STAT.REPORT.HEAD<RE.SRH.COLUMN.TYPE,1> SETTING Y.CRMOV.POS THEN
        Y.COLUMN.FOUND = 1
    END

    IF NOT(Y.COLUMN.FOUND) THEN
        AF = SAP.EP.REPORT.NAME
        AV = Y.REPORT.INIT
        ETEXT = 'RE-IN.DEBIT.OR.CREDIT.MVMT'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
CHECK.GL.IND.DESCRIPTION:
*************************
* In this para of the code, the GL IND and DESCRIPTION values are cross checked with the number of multi-values
** in the application RE.STAT.REP.LINE with @ID like REPORT.NAME

    SEL.CMD = 'SELECT ':FN.RE.STAT.REP.LINE:' WITH @ID LIKE ':R.NEW(SAP.EP.REPORT.NAME)<1,Y.REPORT.INIT,Y.SREPORT.INIT>:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    RE.STAT.REP.LINE.ID = SEL.LIST<1>
    GOSUB READ.RE.STAT.REP.LINE

    Y.MULTI.COUNT = DCOUNT(R.RE.STAT.REP.LINE<RE.SRL.DESC>,@VM)

    IF Y.MULTI.COUNT LT R.NEW(SAP.EP.N.GL.IND)<1,Y.REPORT.INIT> THEN
        AF = SAP.EP.N.GL.IND
        AV = Y.REPORT.INIT
        ETEXT = 'RE-IN.INVALID.MULTIVALUE.NUMBER'
        CALL STORE.END.ERROR
    END

    IF Y.MULTI.COUNT LT R.NEW(SAP.EP.GL.DESCRIPTION)<1,Y.REPORT.INIT> THEN
        AF = SAP.EP.GL.DESCRIPTION
        AV = Y.REPORT.INIT
        ETEXT = 'RE-IN.INVALID.MULTIVALUE.NUMBER'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
CHECK.EXTRACT.ARCH.PATH:
************************
* In this para of the code, the PATHs specified in EXTRACT PATH and ARCHIVAL PATH are checked if exists or not

    OPEN R.NEW(SAP.EP.EXTRACT.OUT.PATH)<1,Y.REPORT.INIT> TO F.EXTRACT.PATH  ELSE

        AF = SAP.EP.EXTRACT.OUT.PATH
        AV = Y.REPORT.INIT
        ETEXT = 'RE-IN.INVALID.PATH'
        CALL STORE.END.ERROR
    END

*    OPEN R.NEW(SAP.EP.GL.ARC.PATH)<1,Y.REPORT.INIT> TO F.ARCH.PATH  ELSE
*        AF = SAP.EP.GL.ARC.PATH
*        AV = Y.REPORT.INIT
*        ETEXT = 'RE-IN.INVALID.PATH'
*        CALL STORE.END.ERROR
*    END

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.EXTRACT.TYPE:
*******************
    BEGIN CASE

        CASE R.NEW(SAP.EP.GIT.ROUTINE)<1,Y.REPORT.INIT> MATCHES 'SAP.DETAIL.REPORT':@VM:'SAP.DETAIL.REPORT.PL'       ;*PACS00072689 - S/E
            IF R.NEW(SAP.EP.TYPE.OF.EXTRACT)<1,Y.REPORT.INIT> EQ 'SUMMARY' THEN
                AF = SAP.EP.TYPE.OF.EXTRACT
                AV = Y.REPORT.INIT
                ETEXT = 'RE-INVALID.EXT.TYPE'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(SAP.EP.GIT.ROUTINE)<1,Y.REPORT.INIT> MATCHES 'SAP.NORMAL.EXTRACT':@VM:'SAP.NORMAL.EXTRACT.PL'     ;*PACS00072689 - S/E
            IF R.NEW(SAP.EP.TYPE.OF.EXTRACT)<1,Y.REPORT.INIT> EQ 'DETAIL' THEN
                AF = SAP.EP.TYPE.OF.EXTRACT
                AV = Y.REPORT.INIT
                ETEXT = 'RE-INVALID.EXT.TYPE'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(SAP.EP.GIT.ROUTINE)<1,Y.REPORT.INIT> MATCHES 'SAP.REVAL.EXTRACT':@VM:'SAP.REVAL.EXTRACT.PL'       ;*PACS00072689 - S/E
            IF R.NEW(SAP.EP.TYPE.OF.EXTRACT)<1,Y.REPORT.INIT> EQ 'DETAIL' THEN
                AF = SAP.EP.TYPE.OF.EXTRACT
                AV = Y.REPORT.INIT
                ETEXT = 'RE-INVALID.EXT.TYPE'
                CALL STORE.END.ERROR
            END

    END CASE

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
READ.RE.STAT.REPORT.HEAD:
*************************
* In this para of the code, file RE.STAT.REPORT.HEAD is read
    R.RE.STAT.REPORT.HEAD  = ''
    RE.STAT.REPORT.HEAD.ER = ''
    CALL CACHE.READ(FN.RE.STAT.REPORT.HEAD, RE.STAT.REPORT.HEAD.ID, R.RE.STAT.REPORT.HEAD, RE.STAT.REPORT.HEAD.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.RE.STAT.REP.LINE:
**********************
* In this para of the code, file RE.STAT.REP.LINE is read
    R.RE.STAT.REP.LINE  = ''
    RE.STAT.REP.LINE.ER = ''
    CALL F.READ(FN.RE.STAT.REP.LINE,RE.STAT.REP.LINE.ID,R.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE,RE.STAT.REP.LINE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
