$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.ACC.ID(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.E.BLD.ACC.ID
*-------------------------------------------------------------------------

* Description : This is a Build routine which will be executed to display the
* internal account of the certified cheques

* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
* Linked with : Build routine for the enquiry ENQ.CERT.CHEQ.ACCT.NO
*-------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    GOSUB PROCESS
RETURN
PROCESS:
***********
    LOCATE '@ID'IN ENQ.DATA<2,1> SETTING Y.POS THEN
        ENQ.DATA<4,Y.POS>=ID.COMPANY
    END
RETURN
************************************************************************
END
