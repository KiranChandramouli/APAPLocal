* @ValidationCode : MjotMTIyODI5MDY2OkNwMTI1MjoxNjg0ODQyMTQzNDgyOklUU1M6LTE6LTE6LTM2OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -36
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.AZ.REINV.FREQ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $USING APAP.REDOVER

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date            Who                 Reference            Description
* 17-Apr-2010     Sudharsanan S       PACS00192055         INITIAL VERSION
* 25-03-2012      Vignesh Kumaar M R  PACS00245121         Frequency to be defaulted to Mat date when it is LT 31 days
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     > TO GT, = TO EQ, ELSE BLOCK ADDED
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
* ----------------------------------------------------------------------------

    NO.OF.DAYS = ''

    IF OFS$HOT.FIELD EQ 'Tab.VALUE.DATE' OR OFS$HOT.FIELD EQ 'VALUE.DATE' THEN
        GET.VALUE.DATE = COMI
    END ELSE
        GET.VALUE.DATE = R.NEW(AZ.VALUE.DATE)
    END

    GET.MATURITY.DATE = R.NEW(AZ.MATURITY.DATE)

    GOSUB PROCESS
*CALL REDO.V.PRINCIPAL.INT.RATE
*R22 MANUAL CONVERSION
*APAP.REDOVER.REDO.V.PRINCIPAL.INT.RATE ;*R22 MANUAL CODE CONVERSION
    APAP.REDOVER.redoVPrincipalIntRate() ;*R22 MANUAL CODE CONVERSION

RETURN

*********
PROCESS:
*********

* Fix for PACS00245121 [Frequency to be defaulted to Mat date when it is LT 31 days]

    IF NOT(GET.MATURITY.DATE) THEN

        RETURN
    END

    Y1 = GET.VALUE.DATE[7,2]:"/":GET.VALUE.DATE[5,2]:"/":GET.VALUE.DATE[1,4]
    Y1 = ICONV(Y1,"D4E")
    Y2 = GET.MATURITY.DATE[7,2]:"/":GET.MATURITY.DATE[5,2]:"/":GET.MATURITY.DATE[1,4]
    Y2 = ICONV(Y2,"D4E")
    NO.OF.DAYS = Y2 - Y1


    IF NO.OF.DAYS LT 31 THEN

        R.NEW(AZ.FREQUENCY) = GET.MATURITY.DATE
    END ELSE

* End of Fix

        GOSUB SET.MONTHLY.FREQ
    END

RETURN

SET.MONTHLY.FREQ:
*----------------
    Y.DATE = COMI
    Y.DATE.BK = Y.DATE

    IF Y.DATE[5,2] EQ '01' THEN ;*R22 AUTO CONVERSION
        GOSUB CHECK.FEB.MON
    END
    ELSE ;*R22 AUTO CONVERSION
        IF Y.DATE[5,2] EQ '02' THEN ;*R22 AUTO CONVERSION
            IF MOD(Y.DATE[1,4],4) GT 0 THEN ;*R22 AUTO CONVERSION
                Y.DAYS = '+28C'
                CALL CDT('',Y.DATE,Y.DAYS)
            END ELSE
                Y.DAYS = '+29C'
                CALL CDT('',Y.DATE,Y.DAYS)
            END
        END
        ELSE
            Y.DAYS = "+31C"
            CALL CDT('',Y.DATE,Y.DAYS)
        END ;*R22 AUTO CONVERSION
    END


*    CALL AWD('',Y.DATE,DATE.TYPE)

*    IF DATE.TYPE EQ 'H' THEN
*        Y.DAYS = "-1W"
*        CALL CDT('',Y.DATE,Y.DAYS)
*    END

    VAR.SCHEDULES        = R.NEW(AZ.SCHEDULES)
    VAR.CALCULATION.BASE = R.NEW(AZ.CALCULATION.BASE)
    VAR.TYPE.OF.SCHDLE   = R.NEW(AZ.TYPE.OF.SCHDLE)<1,1>
    IF VAR.SCHEDULES EQ "Y" AND VAR.CALCULATION.BASE EQ "SCHEDULED BALANCE" AND VAR.TYPE.OF.SCHDLE EQ "I" THEN
        R.NEW(AZ.FREQUENCY) = Y.DATE:"M01":Y.DATE.BK[7,2]
    END

RETURN

CHECK.FEB.MON:

    IF Y.DATE[7,2] GE "29" THEN
        IF MOD(Y.DATE[1,4],4) GT 0 THEN ;*R22 AUTO CONVERSION
            Y.DATE = Y.DATE[1,4]:'0228'
        END ELSE
            Y.DATE = Y.DATE[1,4]:'0229'
        END
    END ELSE
        Y.DAYS = "+31C"
        CALL CDT('',Y.DATE,Y.DAYS)
    END

RETURN

END
