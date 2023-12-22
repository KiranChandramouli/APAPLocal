* @ValidationCode : MjotMTA1NTI4MjM4NDpVVEYtODoxNzAzMjUzMjAxNjk0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2023 19:23:21
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.INTER.DEPT(ENQ.DATA)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $USING EB.LocalReferences ;*Manual R22 Conversion
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
* 22-12-2023         Narmadha v            Manual R22 Conversion  Call Routine Format Changed
*------------------------------------------------------------------------
*
    GOSUB GET.LOC.REF.POS
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------
GET.LOC.REF.POS:
*------------------------------------------------------------------------
*
*CALL GET.LOC.REF('USER','L.US.IDC.CODE',POS.L.US.IDC.COD)
    EB.LocalReferences.GetLocRef('USER','L.US.IDC.CODE',POS.L.US.IDC.COD) ;*Manual R22 Conversion - Call Routine Format Changed

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
