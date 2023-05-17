SUBROUTINE REDO.GL.V.AUTH.INTRF.REP.LINE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.V.AUTH.INTRF.REP.LINE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.GL.V.AUTH.INTRF.REP.LINE is an AUTHORISATION routine attached to the version,
*                    this routine updates the template REDO.INTRF.REP.LINE with LINE.BALANCE, DESCRIPTION
*                    and AL.PL from RE.STAT.REP.LINE
*Linked With       : Version RE.STAT.REP.LINE,REDO.SAP.GL
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*                    RE.STAT.REP.LINE                 As              I               Mode
*                    REDO.INTRF.REP.LINE              As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 22 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 25 Jun 2011       Pradeep S            PACS00072689                  Validation changed for posting OFS message.\
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.REDO.INTRF.REP.LINE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    IF V$FUNCTION EQ 'I' ELSE
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

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.REDO.INTRF.REP.LINE='F.REDO.INTRF.REP.LINE'
    F.REDO.INTRF.REP.LINE=''
    CALL OPF(FN.REDO.INTRF.REP.LINE,F.REDO.INTRF.REP.LINE)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    IF V$FUNCTION EQ 'I' THEN
        GOSUB UPDATE.INTRF.REP.LINE
    END ELSE
        GOSUB REVERSE.INTRF.REP.LINE
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
UPDATE.INTRF.REP.LINE:
**********************

    IF R.NEW(RE.SRL.LINE.BALANCE) EQ 'DETAIL' OR R.NEW(RE.SRL.LINE.BALANCE) EQ 'SUMMARY' ELSE
        RETURN
    END

    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

    IF NOT(R.REDO.GL.H.EXTRACT.PARAMETER) THEN
        RETURN
    END

    Y.REP.LIST =R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.NAME>
    CHANGE @SM TO @VM IN Y.REP.LIST
    LOCATE FIELD(ID.NEW,".",1) IN Y.REP.LIST<1,1> SETTING Y.REP.POS ELSE
        RETURN
    END

    REDO.INTRF.REP.LINE.ID = ID.NEW
    GOSUB READ.REDO.INTRF.REP.LINE

    R.REDO.INTRF.REP.LINE<SAP.INTRF.LINE.BALANCE> = R.NEW(RE.SRL.LINE.BALANCE)
    R.REDO.INTRF.REP.LINE<SAP.INTRF.DESC>         = R.NEW(RE.SRL.DESC)
    IF NOT(R.OLD(RE.SRL.CURR.NO)) THEN
        R.REDO.INTRF.REP.LINE<SAP.INTRF.IS.CONTINGENT>='NO'
    END

*PACS00072689 - S
*IF NOT(R.NEW(RE.SRL.ASSET.APPLIC.ID)) THEN
*RETURN
*END


*IF R.NEW(RE.SRL.ASSET.APPLIC.ID) NE "" OR R.NEW(RE.SRL.ASSET.EXT.DUP) EQ "DEF" THEN
*R.REDO.INTRF.REP.LINE<SAP.INTRF.AL.PL> = 'AL'
*END ELSE
*IF R.NEW(RE.SRL.PROFT.APPLIC.ID) NE "" OR R.NEW(RE.SRL.PROFT.EXT.DUP) NE "" THEN
*R.REDO.INTRF.REP.LINE<SAP.INTRF.AL.PL> = 'PL'
*END
*END
    R.REDO.INTRF.REP.LINE<SAP.INTRF.AL.PL> = ''

    BEGIN CASE

        CASE R.NEW(RE.SRL.ASSET.APPLIC.ID) NE ""  OR R.NEW(RE.SRL.ASSET.EXT.DUP) NE ""
            R.REDO.INTRF.REP.LINE<SAP.INTRF.AL.PL> = 'AL'
        CASE R.NEW(RE.SRL.PROFT.APPLIC.ID) NE ""  OR R.NEW(RE.SRL.PROFT.EXT.DUP) NE ""
            R.REDO.INTRF.REP.LINE<SAP.INTRF.AL.PL> = 'PL'
    END CASE

*PACS00072689 - E
    GOSUB CALL.OFS.POST.MESSAGE

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CALL.OFS.POST.MESSAGE:
**********************

    OFS.SOURCE.ID  = 'SAP.OFS.SOURCE'
    APP.NAME       = 'REDO.INTRF.REP.LINE'
    OFSFUNCT       = 'I'
    PROCESS        = 'PROCESS'
    OFSVERSION     = 'REDO.INTRF.REP.LINE,REDO.SAP.REV'
    GTSMODE        = ''
    NO.OF.AUTH     = 0
    TRANSACTION.ID = REDO.INTRF.REP.LINE.ID
    OFSRECORD      = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.REDO.INTRF.REP.LINE,OFSRECORD)

    OFS.MSG.ID  = ''
    OFS.MSG.ERR = ''

    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.MSG.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
REVERSE.INTRF.REP.LINE:
***********************
    OFS.SOURCE.ID = 'SAP.OFS.SOURCE'
    OFS.MSG.ID    = ''
    OPTIONS       = ''
    Y.OFS.BODY    = ''
    Y.OFS.HEADER  = "REDO.INTRF.REP.LINE,REDO.SAP.REV/R/PROCESS,/,":ID.NEW
    Y.OFS.MSG     = Y.OFS.HEADER

    CALL OFS.POST.MESSAGE(Y.OFS.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
* In this para of the code, file REDO.GL.H.EXTRACT.PARAMETER is read
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
READ.REDO.INTRF.REP.LINE:
*************************
* In this para of the code, file REDO.INTRF.REP.LINE is read
    R.REDO.INTRF.REP.LINE  = ''
    REDO.INTRF.REP.LINE.ER = ''
    CALL F.READ(FN.REDO.INTRF.REP.LINE,REDO.INTRF.REP.LINE.ID,R.REDO.INTRF.REP.LINE,F.REDO.INTRF.REP.LINE,REDO.INTRF.REP.LINE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
