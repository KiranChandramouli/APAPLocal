$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.INTER.DEPT(ENQ.DATA)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Bharath G
* Program Name : REDO.E.BLD.INTER.DEPT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to enquiry ENQUIRY>REDO.FT.DISBURSE.LIST.INTER.DEPT
*-------------------------------------------------------------------------
* Linked with : REDO.LIST.DEPT.CODE
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
* DATE ODR / HD REF DESCRIPTION
* 16-08-11 PACS00100502 Routine to show department of company.
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
*
    GOSUB GET.LOC.REF.POS
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------
GET.LOC.REF.POS:
*------------------------------------------------------------------------
*
    CALL GET.LOC.REF('USER','L.US.IDC.CODE',POS.L.US.IDC.COD)

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
*
    Y.DEPT.VAL = ''
    Y.DEPT.VAL = R.USER<EB.USE.LOCAL.REF,POS.L.US.IDC.COD>

    ENQ.DATA<2,-1> = "BRANCH.ID"
    ENQ.DATA<3,-1> = "EQ"
    ENQ.DATA<4,-1> = Y.DEPT.VAL

RETURN
END
