* @ValidationCode : Mjo5Mzc5NzcyODY6Q3AxMjUyOjE2ODA2MDgzODAzMzI6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:09:40
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
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ , COVERT TO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

SUBROUTINE DR.GET.FREQ.CODE(FREQ.CODE,N.FREQ.CODE)
* Incomming -
*      FREQ.CODE - T24 frequency
* Outgoing -
*      FREQ.CODE - Reporting code
*
*-----------------------------------------------
    CHANGE ' ' TO @VM IN FREQ.CODE  ;*R22 AUTO CODE CONVERSION

    NO.OF.TYP = DCOUNT(FREQ.CODE,@VM)

AA.FREQ:
*---------

    FOR ITYP = 1 TO NO.OF.TYP
        CUR.TYP =  FREQ.CODE<1,ITYP>
        LEN.CUR.TYP = LEN(CUR.TYP)
        LEN.CUR.TYP -= 2

        BEGIN CASE

            CASE CUR.TYP[1] EQ 'Y' ;*R22 AUTO CODE CONVERSION
                IF CUR.TYP[2,LEN.CUR.TYP] THEN
                    RET.FREQ = 'A' ; N.FREQ.CODE = 1

                END
            CASE CUR.TYP[1] EQ 'M' ;*R22 AUTO CODE CONVERSION
                IF CUR.TYP[2,LEN.CUR.TYP] THEN
                    BEGIN CASE
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 1
                            RET.FREQ = 'M' ; N.FREQ.CODE =  12
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 2
                            RET.FREQ = 'B' ; N.FREQ.CODE =  6
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 3
                            RET.FREQ = 'T' ; N.FREQ.CODE = 4
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 4
                            RET.FREQ = 'C' ; N.FREQ.CODE = 3
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 6
                            RET.FREQ = 'S' ; N.FREQ.CODE = 2
                        CASE CUR.TYP[2,LEN.CUR.TYP] EQ 12
                            RET.FREQ = 'A' ; N.FREQ.CODE = 1
                    END CASE
                END

        END CASE
    NEXT ITYP
    FREQ.CODE = RET.FREQ
RETURN
