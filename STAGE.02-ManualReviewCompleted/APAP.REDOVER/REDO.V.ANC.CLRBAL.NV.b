* @ValidationCode : MjoxODMwODA3MTYxOkNwMTI1MjoxNjgwNzc1NDY4MDkyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:34:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ANC.CLRBAL.NV
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.ANC.CLRBAL.NV
* ODR NO      :
*----------------------------------------------------------------------
*DESCRIPTION: This routine is auto new content routine attached to L.INITIAL.ID field in

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER.ID
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                WHO                           REFERENCE                 DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM, VM TO @VM
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
*
    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
*
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("TELLER.ID",WCAMPO,YPOS)
    WPOSLI  = YPOS<1,1>
    WCASH   = YPOS<1,2>
    WCHECK  = YPOS<1,3>
    WCCY    = YPOS<1,4>
*
RETURN


*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    R.NEW(TT.TID.LOCAL.REF)<1,WPOSLI> = ""
    R.NEW(TT.TID.LOCAL.REF)<1,WCASH>  = ""
    R.NEW(TT.TID.LOCAL.REF)<1,WCHECK> = ""
    R.NEW(TT.TID.LOCAL.REF)<1,WCCY>   = ""

RETURN
END
