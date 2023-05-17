* @ValidationCode : MjozMTczNjI5NTg6Q3AxMjUyOjE2ODQyMjI4MTA1Nzg6SVRTUzotMTotMTotMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.INTERES.SIMULATION
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE               WHO            REFERENCE               DESCRIPTION

* 21-APR-2023    Conversion tool    R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion   call routine format modified

*-----------------------------------------------------------------------------
    
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.INTEREST ;*R22 Auto conversion -END
    $USING APAP.AA
    
    AA.ID = COMI
    CALL APAP.AA.redoBConLnsByDebtorAaRecs(AA.ID,OUT.RECORD) ;*Manual R22 conversion
    R.AA.INTEREST.APP         = FIELD(OUT.RECORD,"*",7)
    Y.RATE= R.AA.INTEREST.APP<AA.INT.FIXED.RATE,1>
    COMI = Y.RATE
END
