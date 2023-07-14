* @ValidationCode : MjotMjA5MDkxODM0OTpDcDEyNTI6MTY4Mjg0NDg2MTI3MzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Apr 2023 14:24:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TELLER.CASH.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.TELLER.CASH.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Description: This routine is an .VALIDATE routine.
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.CASH.MENU.PARAM
    $INSERT I_F.VERSION

    GOSUB PROCESS

RETURN

PROCESS:
*-------

    FN.REDO.TELLER.CASH.MENU.PARAM='F.REDO.TELLER.CASH.MENU.PARAM'
    F.REDO.TELLER.CASH.MENU.PARAM=''

    CALL OPF(FN.REDO.TELLER.CASH.MENU.PARAM,F.REDO.TELLER.CASH.MENU.PARAM)

    FN.VERSION='F.VERSION'
    F.VERSION=''

    CALL OPF(FN.VERSION,F.VERSION)


    AF = TT.CASH.VERSION.NAME

    CALL DUP

    IF ETEXT THEN
        CALL STORE.END.ERROR
    END

RETURN

END
