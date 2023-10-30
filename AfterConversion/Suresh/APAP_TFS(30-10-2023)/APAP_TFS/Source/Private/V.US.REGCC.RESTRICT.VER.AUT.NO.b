* @ValidationCode : MjotNDk0NTE4ODIyOkNwMTI1MjoxNjk4MzEyNTE2MjcxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:58:36
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
$PACKAGE APAP.TFS
SUBROUTINE V.US.REGCC.RESTRICT.VER.AUT.NO
*
* Subroutine to restrict versions using Reg CC, to Self Authoriser
* versions only.
*
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION

    REGCC.API = 'V.US.REGCC.BUILD.EXPOSURE'
    VERSION.APIS = R.VERSION(EB.VER.VALIDATION.RTN)
    IF VERSION.APIS THEN
        LOCATE '@':REGCC.API IN VERSION.APIS<1,1> SETTING REGCC.VERSION THEN
            IF R.VERSION(EB.VER.NO.OF.AUTH) EQ '' OR R.VERSION(EB.VER.NO.OF.AUTH) THEN
                E = 'EB-US.REGCC.ONLY.SELF.AUTH.VERSION.ALLOWED'
                CALL ERR
                V$ERROR = 1
                MESSAGE = 'REPEAT'
            END
        END
    END

RETURN
END
