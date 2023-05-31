$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.TEMP.GET.PDISB.VER

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : TAM
* Program Name : REDO.E.GET.PDISB.VER
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to ENQUIRY REPO.E.PART.DESEMBOLSO
*               It should get the VERSION NAME corresponding to next not initiated disbursement
*
*----------------------------------------------------------
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
* DATE         NAME          REFERENCE     COMMENTS
*
* 15-Mar-2013  Sivakumar.K   PACS00255148  O.DATA should be null if CODTXN is found
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    $INSERT I_F.REDO.FC.TEMP.DISB
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
*
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
*
RETURN
*
* =========
INITIALIZE:
* =========
*
    WFOUND        = ""
    WNEXT.DISB    = ""
*
    FN.REDO.FC.TEMP.DISB = "F.REDO.FC.TEMP.DISB"
    F.REDO.FC.TEMP.DISB  = ""
    CALL OPF(FN.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB)
*
    FN.REDO.AA.PART.DISBURSE.FC = "F.REDO.AA.PART.DISBURSE.FC"
    F.REDO.AA.PART.DISBURSE.FC = ""
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======
PROCESS:
* ======
*
    WRCA.AA.ID = O.DATA
    CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WRCA.AA.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ)
    R.RCA = R.REDO.AA.PART.DISBURSE.FC
    GOSUB GET.DISB.INFO
*
RETURN
*
*
* ============
GET.DISB.INFO:
* ============
*
    WRCA.CODTXN   = R.RCA<REDO.PDIS.DIS.CODTXN>
    WRCA.DIS.TYPE = R.RCA<REDO.PDIS.DIS.TYPE>
    WDISB.POS     = 0
*
    LOOP
        REMOVE WDIS.TYPE FROM WRCA.DIS.TYPE SETTING TXN.POS
    WHILE WDIS.TYPE:TXN.POS AND NOT(WFOUND) DO
        REMOVE WTXN.ID FROM WRCA.CODTXN SETTING TXN.POS
        WDISB.POS += 1
        IF WTXN.ID EQ "" AND NOT(WFOUND) THEN
            WFOUND  = 1
            CALL F.READ(FN.REDO.FC.TEMP.DISB,WDIS.TYPE,R.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB,ERR.RFD)
            IF R.REDO.FC.TEMP.DISB THEN
                O.DATA = R.REDO.FC.TEMP.DISB<FC.TD.NAME.PART.VRN>
            END

*PACS00255148_S
        END ELSE
            O.DATA = ""
        END
*PACS00255148_E

    REPEAT

RETURN
*
END
