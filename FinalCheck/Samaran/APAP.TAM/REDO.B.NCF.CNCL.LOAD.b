$PACKAGE APAP.TAM
SUBROUTINE REDO.B.NCF.CNCL.LOAD
* ----------------------------------------------------------------------------------------------------------------
* Description           : To initialise all the necessary files and variables to extract the details that Contains
*                         the NCF that are cancelled for various reasons (bad impression, deterioration of the
*                         invoice, invoice duplication, etc..)
* Developed By          : Aravindhan B
* Development Reference : N10
* Attached To           : NA
* Attached As           : NA
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
*-----------------------------------------------------------------------------------------------------------------
* Modification History
**********************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
*
* 05/12/2014  Ashokkumar.V.P        PACS00350467 - Fixed the report frequency issue
* 03/04/2015  Ashokkumar.V.P        PACS00350467 - Changed the header year length.
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_REDO.B.NCF.CNCL.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCELLED ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCEL ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
*   $INSERT I_BATCH.FILES ;* R22 Auto conversion
*--------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB READ.REDO.H.REPORTS.PARAM
    GOSUB GET.PARAM.FLD.VALS
*    GOSUB SELECT.NCF.CANCEL
RETURN
*--------------------------------------------------------------------------
INIT:
***** *** To initialise all variables ***
*---------Changes as per Baselined TSD----------------*
    Y.SESSION.NO = '' ; Y.DATE.REQ = '' ; Y.FREQ.REQ = '' ;Y.RCL.ID = '' ; Y.REDO.H.REPORTS.PARAM.ID = '' ;
    Y.REDO.L.NCF.CANCEL.LIST = '' ; Y.FILE.NAME = '' ; Y.FIELD.NME.ARR = '' ; Y.FIELD.VAL.ARR = '' ; Y.DISP.TEXT.ARR = '' ;
    Y.FILE.DIR = ''
*---------Changes as per Baselined TSD----------------*
RETURN
*--------------------------------------------------------------------------
OPENFILES:
********** *** To open required files ***

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.L.NCF.CANCELLED  = 'F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED = ''
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)

    FN.REDO.L.NCF.CANCEL = 'F.REDO.L.NCF.CANCEL'
    F.REDO.L.NCF.CANCEL = ''
    CALL OPF(FN.REDO.L.NCF.CANCEL,F.REDO.L.NCF.CANCEL)


    Y.SESSION.NO = AGENT.NUMBER ;* R22 Auto conversion
    Y.REDO.H.REPORTS.PARAM.ID =  BATCH.DETAILS<3,1,1>
    Y.RCL.ID = BATCH.DETAILS<3,1,2>
RETURN
*--------------------------------------------------------------------------
READ.REDO.H.REPORTS.PARAM:
************************** *** Read the Parameter table to get the required field values ****

    R.REDO.H.REPORTS.PARAM = '' ; REDO.H.REPORTS.PARAM.ERR = ''
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,Y.REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
RETURN
*--------------------------------------------------------------------------
GET.PARAM.FLD.VALS:
******************
    YLAST.DTE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.DATE.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.YEAR.MONTH>
        Y.FREQ.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FREQUENCY.REQ>
*---------Changes as per Baselined TSD----------------*
        BEGIN CASE
            CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Yearly'
                Y.DATE.REQ = Y.DATE.REQ[1,4]
            CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Monthly'
                Y.DATE.REQ = Y.DATE.REQ[1,6]
            CASE Y.FREQ.REQ EQ 'Yearly'
                Y.DATE.REQ = YLAST.DTE[1,4]
            CASE (Y.FREQ.REQ EQ 'Monthly') OR Y.FREQ.REQ EQ ''
                Y.DATE.REQ = YLAST.DTE[1,6]
        END CASE

        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        Y.FILE.NAME = Y.FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;* R22 Auto conversion
        Y.FILE.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.FILE.DIR
        OPENSEQ Y.FILE.DIR,Y.FILE.NAME TO Y$.SEQFILE.PTR ELSE
            CREATE Y.FILE.NAME ELSE
                Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
                GOSUB FATAL.ERROR.LOG
                RETURN
            END
        END
    END
*---------Changes as per Baselined TSD----------------*
*
RETURN
*--------------------------------------------------------------------------
SELECT.NCF.CANCEL:
****************** *** Select the table REDO.L.NCF.CANCEL and save the list in common variable Y.REDO.L.NCF.CANCEL.LIST
    SEL.CMD.CNCL = "SELECT ":FN.REDO.L.NCF.CANCEL
    CALL EB.READLIST(SEL.CMD.CNCL,SEL.LIST.CNCL,'',NO.OF.RECS.CNCL,RET.ERR.CNCL)
*---------Changes as per Baselined TSD----------------*
    LOOP
        REMOVE Y.REDO.L.NCF.CANCEL.LIST FROM SEL.LIST.CNCL SETTING Y.NCF.POS
    WHILE Y.REDO.L.NCF.CANCEL.LIST : Y.NCF.POS
        R.REDO.L.NCF.CANCEL = ''
        CALL F.READ(FN.REDO.L.NCF.CANCEL,Y.REDO.L.NCF.CANCEL.LIST,R.REDO.L.NCF.CANCEL,F.REDO.L.NCF.CANCEL,ERR.REDO.L.NCF.CANCEL)
        IF R.REDO.L.NCF.CANCEL THEN
            Y.REDO.L.NCF.CANCEL.IDS = R.REDO.L.NCF.CANCEL<ST.TRANSACTION.ID>
            Y.REDO.CANCEL.TYPE = R.REDO.L.NCF.CANCEL<ST.CANCEL.TYPE>
            IF Y.REDO.L.NCF.CANCEL.IDS THEN
                Y.REDO.L.NCF.CANCEL.IDS.ARR<-1> = Y.REDO.L.NCF.CANCEL.IDS
                Y.REDO.CANCEL.TYPE.ARR<-1> = Y.REDO.CANCEL.TYPE
            END
        END
    REPEAT

*---------Changes as per Baselined TSD----------------*
RETURN
*--------------------------------------------------------------------------
FATAL.ERROR.LOG:
****************
    MON.TP = 04
    REC.CON = "N10"
    DESC = "N10"
    INT.CODE = "REP001"
    INT.TYPE = "ONLINE"
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL  REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT, INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON, EX.USER,EX.PC)
RETURN

END
