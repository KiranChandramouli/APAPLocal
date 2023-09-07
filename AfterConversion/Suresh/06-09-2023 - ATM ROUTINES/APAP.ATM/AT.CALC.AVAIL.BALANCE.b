* @ValidationCode : MjoxMjcyNjU3NzI6Q3AxMjUyOjE2OTM4MTMwNjgzODY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Sep 2023 13:07:48
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
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
 



SUBROUTINE AT.CALC.AVAIL.BALANCE(R.ACCT,WRK.BAL,AVAIL.BAL)
*/rtn to calculate the available balance to return
*/AVAIL.BAL = WORK.BAL - LOCKED.AMT - TXN.AMT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.CURRENCY



    GOSUB INITIALISE
    GOSUB PROCESS
RETURN


*
INITIALISE:
*--------*
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

RETURN

*
PROCESS:
*____________*

    IF R.ACCT<AC.FROM.DATE> THEN
        U.LOCK.AMT =0
        U.CTR = DCOUNT(R.ACCT<AC.FROM.DATE>, @VM)
        FOR U.I = 1 TO U.CTR

            IF TODAY GE R.ACCT<AC.FROM.DATE, U.I> THEN

                U.LOCK.AMT = R.ACCT<AC.LOCKED.AMOUNT,U.I>
            END
        NEXT U.I

        IF WRK.BAL LT 0 THEN
            AVAIL.BAL = ABS(WRK.BAL) + U.LOCK.AMT
            AVAIL.BAL = AVAIL.BAL * -1
        END ELSE
            AVAIL.BAL = WRK.BAL - U.LOCK.AMT
        END
    END ELSE

        AVAIL.BAL = WRK.BAL

    END
RETURN
