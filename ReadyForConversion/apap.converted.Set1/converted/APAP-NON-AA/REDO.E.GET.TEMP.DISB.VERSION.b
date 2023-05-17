SUBROUTINE REDO.E.GET.TEMP.DISB.VERSION
****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JOAQUIN COSTA C. - jcosta@temenos.com
* Program Name : REDO.E.GET.TEMP.DISB.VERSION
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to ENQUIRY REPO.E.DESEMBOLSO
*               It should get the VERSION NAME corresponding to next not initiated disbursement
*
*----------------------------------------------------------
*    Linked TO : Enquiry REDO.E.DESEMBOLSO
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
* 09-06-2017        Edwin Charles D  R15 Upgrade       Update
*----------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    $INSERT I_F.REDO.FC.TEMP.DISB
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
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
    F.REDO.FC.TEMP.DISB = ""
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
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
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WRCA.AA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
    R.RCA = R.REDO.CREATE.ARRANGEMENT
    GOSUB GET.DISB.INFO
*
RETURN
*
*
* ============
GET.DISB.INFO:
* ============
*
    WRCA.CODTXN   = R.RCA<REDO.FC.DIS.CODTXN>
    WRCA.DIS.TYPE = R.RCA<REDO.FC.DIS.TYPE>
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
                O.DATA = R.REDO.FC.TEMP.DISB<FC.TD.NAME.VRN>
            END
        END
    REPEAT

RETURN
*
END
