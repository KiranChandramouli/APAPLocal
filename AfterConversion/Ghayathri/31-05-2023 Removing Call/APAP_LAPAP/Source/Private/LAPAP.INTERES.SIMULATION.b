* @ValidationCode : MjoxNTgzNDE5NDQwOkNwMTI1MjoxNjg1NTM0MTI2MDkyOmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:25:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
    APAP.AA.redoBConLnsByDebtorAaRecs(AA.ID,OUT.RECORD) ;*Manual R22 conversion
    R.AA.INTEREST.APP         = FIELD(OUT.RECORD,"*",7)
    Y.RATE= R.AA.INTEREST.APP<AA.INT.FIXED.RATE,1>
    COMI = Y.RATE
END
