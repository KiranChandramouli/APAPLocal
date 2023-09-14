$PACKAGE APAP.TAM
SUBROUTINE REDO.B.NCF.CNCL(REDO.L.NCF.CANCELLED.ID)
* ----------------------------------------------------------------------------------------------------------------
* Description           : To extract the details that Contains the NCF that are cancelled for various reasons
*                         (bad impression, deterioration of the invoice, invoice duplication, etc..)
* Developed By          : Aravindhan B
* Development Reference : N10
* Attached To           : BATCH>BNK/REDO.B.NCF.CNCL
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : REDO.L.NCF.CANCELLED.ID
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*                        Vijayarani G                   29-OCT-2013           Changes done as per the Review commands of Baselined TSD
*                        Amaravathi Krithika B          27-FEB-2014           Changes done as per the Clarification Provided
*  PACS00350467          Ashokkumar.V.P                 05-Dec-2014           Corrected the selection and initialised the common variables
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_REDO.B.NCF.CNCL.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCELLED ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCEL ;* R22 Auto conversion
*--------------------------------------------------------------------------

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------
PROCESS:
******** *** To get the bill date, TXN ref and NCF from REDO.L.NCF.CANCELLED ***
    C$SPARE(451)= '';  C$SPARE(452)= '';  C$SPARE(453)= ''
    IF REDO.L.NCF.CANCELLED.ID THEN
        GOSUB READ.REDO.L.NCF.CANCELLED
        IF R.REDO.L.NCF.CANCELLED THEN
            Y.NCF.LIST = R.REDO.L.NCF.CANCELLED<NCF.CAN.NCF>
            Y.BILL.DATE = FIELD(REDO.L.NCF.CANCELLED.ID,'.',2,1)
            Y.TXN.ID = R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.ID>
            Y.CANCEL.TYPE = R.REDO.L.NCF.CANCELLED<NCF.CAN.CAN.TYPE>
            C$SPARE(452)= Y.BILL.DATE
            C$SPARE(453)= Y.CANCEL.TYPE
*            GOSUB CHK.NCF.CNCL.LIST
            GOSUB CHK.NCF.LIST
        END ELSE
            GOSUB FATAL.ERROR.LOG
        END
    END
RETURN
*-----------------------------------------------------------------------------------------

CHK.NCF.CNCL.LIST:
****************** *** To get cancel type of corresponding transaction ***
*---------Changes as per Baselined TSD----------------*
    Y.CANCEL.TYPE  = ''
    LOCATE Y.TXN.ID IN Y.REDO.L.NCF.CANCEL.IDS.ARR<1> SETTING TXN.POS THEN
        Y.CANCEL.TYPE  = Y.REDO.CANCEL.TYPE.ARR<TXN.POS>
    END
    C$SPARE(453)= Y.CANCEL.TYPE
*---------Changes as per Baselined TSD----------------*
RETURN

*-----------------------------------------------------------------------------------------

CHK.NCF.LIST:
************* *** To process each NCF ***

    R.REDO.REPORT.DUMMY = ''
    LOOP
        REMOVE Y.NCF FROM Y.NCF.LIST SETTING Y.NCF.POS
    WHILE Y.NCF:Y.NCF.POS
        C$SPARE(451) = Y.NCF
        MAP.FMT = 'MAP'
        ID.RCON.L = Y.RCL.ID
        ID.APP = REDO.L.NCF.CANCELLED.ID
        R.APP = R.REDO.L.NCF.CANCELLED
        APP = FN.REDO.L.NCF.CANCELLED
        R.RETURN.MSG= ''
        ERR.MSG= ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        IF R.REDO.REPORT.DUMMY THEN
            R.REDO.REPORT.DUMMY := @FM:R.RETURN.MSG
        END ELSE
            R.REDO.REPORT.DUMMY = R.RETURN.MSG
        END
    REPEAT
    GOSUB WRITE.REDO.REPORT.TEMP
RETURN
*-----------------------------------------------------------------------------------------

WRITE.REDO.REPORT.TEMP:
***********************
*---------Changes as per Baselined TSD----------------*
    IF R.REDO.REPORT.DUMMY THEN
        WRITESEQ R.REDO.REPORT.DUMMY APPEND TO Y$.SEQFILE.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB FATAL.ERROR.LOG
            RETURN
        END
    END
RETURN
*---------Changes as per Baselined TSD----------------*
*    CALL F.WRITE(FN.REDO.REPORT.TEMP,Y.REDO.REPORT.TEMP.ID,R.REDO.REPORT.TEMP)
RETURN

READ.REDO.REPORT.TEMP:
**********************
    REDO.REPORT.TEMP.ERR = '' ; R.REDO.REPORT.TEMP = ''
    CALL F.READ(FN.REDO.REPORT.TEMP,Y.REDO.REPORT.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,REDO.REPORT.TEMP.ERR)
RETURN

READ.REDO.L.NCF.CANCELLED:
**************************
    R.REDO.L.NCF.CANCELLED = '' ; REDO.L.NCF.CANCELLED.ERR = ''
    CALL F.READ(FN.REDO.L.NCF.CANCELLED,REDO.L.NCF.CANCELLED.ID,R.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED,REDO.L.NCF.CANCELLED.ERR)
RETURN

*----------------------------------------------------------------------------------------------------------------------
FATAL.ERROR.LOG:
*****************
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
*-----------------------------------------------------------------------------------------
END       ;* End of the Program
