* @ValidationCode : MjoxOTM2NjQwMDk3OkNwMTI1MjoxNjgxODEyOTgxNjcwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 15:46:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRABHU N
* PROGRAM NAME: REDO.VAL.STO.LOC.REF
* ODR NO      :PACS00125978
*----------------------------------------------------------------------
SUBROUTINE REDO.VAL.STO.DUP.LOC.REF
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.REDO.APAP.STO.DUPLICATE

    GOSUB INIT

RETURN

*****
INIT:
****

    START.DATE = COMI

    IF START.DATE LE TODAY THEN
        AF = REDO.SO.STO.START.DATE
        ETEXT = 'EB-DATE.G..TODAY'
        CALL STORE.END.ERROR

    END

    START.DAY=START.DATE[7,2]
    FREQ.MTH='M01'
    END.DATE=R.NEW(REDO.SO.CURRENT.END.DATE)

    IN.FREQ=START.DATE:FREQ.MTH:START.DAY
    CALL EB.CONVERT.FQU.FORMAT(IN.FREQ,OUT.FREQ,ERR.MSG)
    R.NEW(REDO.SO.CURRENT.FREQUENCY)=OUT.FREQ
RETURN
END
