* @ValidationCode : MjoxNjM3NTM5MzAzOkNwMTI1MjoxNjgxMjk1MzU5MDc0OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:59:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.DT.RATE(SP.FW.RATE)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.RATE
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------

*Description    : REDO.APAP.DT.RATE is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*                 the routine reads the SPOT.RATE/FORWARD.RATE and returns the one with value
* In parameter  : None
* out parameter : SP.FW.RATE
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
    GOSUB GET.SP.FW.RATE
RETURN

GET.SP.FW.RATE:
*Get the Currency Details

    IF R.NEW(FX.SPOT.RATE) THEN
        SP.FW.RATE = R.NEW(FX.SPOT.RATE)
    END
    IF R.NEW(FX.FORWARD.RATE) THEN
        SP.FW.RATE = R.NEW(FX.FORWARD.RATE)
    END
RETURN

END
