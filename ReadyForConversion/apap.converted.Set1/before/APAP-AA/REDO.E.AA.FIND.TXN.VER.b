*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.E.AA.FIND.TXN.VER
************************************
* Modification History
*
* 02/03/17 - PACS00574750
*
*
*
************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
************************************
    TXN.ID = O.DATA
*
************************************

    BEGIN CASE
    CASE TXN.ID[1,3] EQ "TFS"
        O.DATA = "TELLER.FINANCIAL.SERVICES"
    CASE TXN.ID AND NUM(TXN.ID) EQ 1
        O.DATA = "PAYMENT.STOP"
    CASE TXN.ID[1,2] EQ "TT"
        O.DATA = "TELLER"
    CASE TXN.ID[1,2] EQ "PD"
        O.DATA = "PD.PAYMENT.DUE"
    CASE TXN.ID[1,2] EQ "LD"
        O.DATA = "LD.LOANS.AND.DEPOSITS"
    CASE TXN.ID[1,2] EQ "MD"
        O.DATA = "MD.DEAL"
    CASE TXN.ID[1,2] EQ "TF"
        O.DATA = "LETTER.OF.CREDIT"
    CASE TXN.ID[1,2] EQ "FT"
        O.DATA = "FUNDS.TRANSFER"
    CASE 1
        O.DATA = "AA.ARRANGEMENT.ACTIVITY,REDO.AA.AUTH"
    END CASE
*
************************************
    RETURN
*
************************************
END

