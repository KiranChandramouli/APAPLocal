*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.PREV.CERT.DEPOSITS.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Amaravathi Krithika B
* Development Reference : CA01
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AZ.ACCOUNT
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_REDO.B.PREV.CERT.DEPOSITS.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM

    GOSUB FORM.START.DATE
    GOSUB SEL.DEPOSITS
    RETURN
FORM.START.DATE:
*---------------
    SEL.LIST.AZ = ''
    Y.STAT.MONTH = Y.LST.WORKING[1,4]:Y.LST.WORKING[5,2]:"01"

    FN.CHK.DIR=R.REDO.REP.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    EXTRACT.FILE.ID= R.REDO.REP.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END

    RETURN
SEL.DEPOSITS:
*-----------
    IF CONTROL.LIST EQ "" THEN
        CONTROL.LIST = "AZ":FM:"ACBAL.HIST"
    END
    BEGIN CASE
    CASE CONTROL.LIST<1> EQ "AZ"
        SEL.AZ.ACC = "SELECT ":FN.AZ.ACC:" WITH VALUE.DATE GE ":Y.STAT.MONTH:" AND VALUE.DATE LE ":Y.LST.WORKING
        CALL EB.READLIST(SEL.AZ.ACC,SEL.LIST.AZ,'',NO.OF.REC,SEL.ERR)
        CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
    CASE CONTROL.LIST<1> EQ "ACBAL.HIST"
        SEL.AZ.HIS = "SELECT ":FN.AZ.ACC.BAL.HIST:" WITH DATE GE ":Y.STAT.MONTH:" AND DATE LE ":Y.LST.WORKING:" BY-DSND @ID "
        CALL EB.READLIST(SEL.AZ.HIS,SEL.LIST.AZ,'',NO.OF.REC,SEL.ERR.HIS)
        CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
    END CASE
    RETURN
END
