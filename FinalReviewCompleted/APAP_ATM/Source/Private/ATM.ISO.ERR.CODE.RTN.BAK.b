* @ValidationCode : MjotNDUwNzYwMzI5OkNwMTI1MjoxNjg0NTAyMzc4MTA0OmFqaXRoOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ATM.ISO.ERR.CODE.RTN.BAK(OUT.MSG)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*    $INCLUDE T24.BP I_F.VERSION
    $INSERT I_F.VERSION        ;*/ TUS START/END
    $INSERT I_AT.ISO.COMMON

    IF NOT(INDEX(OUT.MSG,'/',1)) THEN
        RETURN      ;* Do not execute for routine req applicable tcclient
    END


    STATUS.MSG = FIELD(OUT.MSG,',',1)
    STATUS.MSG = FIELD(STATUS.MSG,'/',3)
    IF STATUS.MSG EQ 1 AND INDEX(OUT.MSG,'RECORD.STATUS:1:1=IHLD',1) AND R.VERSION(EB.VER.GTS.CONTROL) EQ '4'  THEN ;*R22 AUTO CODE CONVERSION
        OUT.MSG:=',Y.ISO.RESPONSE:1:1=00'         ;* We want IHLD
        RETURN

    END
    IF INDEX(OUT.MSG,'RECORD.STATUS:1:1=IHLD',1) THEN
        IF PGM.VERSION EQ ",REV.DUP" THEN

            ISO.RESPONSE = '98'
        END ELSE
            IF PGM.VERSION EQ ",ATM.DUP" THEN
                ISO.RESPONSE = '99'
            END
        END

    END ELSE

        STATUS.MSG = FIELD(OUT.MSG,',',1)
        IF INDEX(STATUS.MSG,'-',1) THEN

            BEGIN CASE
                CASE INDEX(OUT.MSG,'POSTING.RESTRICT',1)
                    ISO.RESPONSE = '05'

                CASE INDEX(OUT.MSG,'LIMIT.EXPIRED',1)
                    ISO.RESPONSE = '05'

                CASE INDEX(OUT.MSG,'EXCESS.AMT',1)
                    ISO.RESPONSE = '05'

                CASE INDEX(OUT.MSG,'OVERRIDEWITHDRAWL.LT.MIN.BAL',1)
                    ISO.RESPONSE = '51'

                CASE INDEX(OUT.MSG,'OVERRIDELT.MINIMUM.BAL',1)
                    ISO.RESPONSE = '51'

                CASE INDEX(OUT.MSG,'OVERRIDEACCT.BAL.LT.LOCKED',1)
                    ISO.RESPONSE = '51'

                CASE INDEX(OUT.MSG,'OVERRIDEACCT.UNAUTH',1)
                    ISO.RESPONSE = '51'

                CASE INDEX(OUT.MSG,'OVERRIDEACCOUNT.INACTIVE',1)
                    ISO.RESPONSE = '05'


                CASE INDEX(OUT.MSG,'OVERRIDEACCT.UNAUTH.OD',1)
                    ISO.RESPONSE = '51'


                CASE INDEX(OUT.MSG,'MISSING',1) AND INDEX(OUT.MSG,'-1',1)
                    ISO.RESPONSE = '05'

                CASE INDEX(OUT.MSG,'LOCKED',1) AND INDEX(OUT.MSG,'FT',1)
                    ISO.RESPONSE = '05'


                CASE INDEX(OUT.MSG,'ACCOUNT',1)
                    ISO.RESPONSE = '51'

                CASE INDEX(OUT.MSG,'OVERRIDE HOLIDAY TABLE ',1)
                    ISO.RESPONSE = '56'


                CASE INDEX(OUT.MSG,'AMOUNT',1)
                    ISO.RESPONSE  = '05'

                CASE INDEX(OUT.MSG,'VALIDATION ERROR',1)
                    ISO.RESPONSE  = '51'

                CASE INDEX(OUT.MSG,'TOO MANY MNEMONIC',1)
                    ISO.RESPONSE  = '76'

                CASE INDEX(OUT.MSG,'EB.RTN.FORMAT',1)
                    ISO.RESPONSE  = '98'

                CASE INDEX(OUT.MSG,'INPUT NOT NUMERIC',1)
                    ISO.RESPONSE  = '30'

                CASE INDEX(OUT.MSG,'TRANSFER ALREADY AUTHORISED',1)
                    ISO.RESPONSE  = '98'
                CASE AT$AT.ISO.RESP.CODE NE '0' AND PGM.VERSION EQ ',REV.WD'
                    ISO.RESPONSE  = AT$AT.ISO.RESP.CODE
                CASE OTHERWISE
                    ISO.RESPONSE = '05'
            END CASE
        END ELSE
            IF AT$AT.ISO.RESP.CODE NE '0' AND PGM.VERSION EQ ',REV.WD' THEN
                ISO.RESPONSE  = AT$AT.ISO.RESP.CODE
            END ELSE
                ISO.RESPONSE  = '00'
            END
        END
    END

    Y.ISO.RESPONSE = ISO.RESPONSE
    OUT.MSG3 = 'Y.ISO.RESPONSE:1:1=':ISO.RESPONSE
    OUT.MSG= OUT.MSG:',':OUT.MSG3

RETURN          ;* Main return
END
