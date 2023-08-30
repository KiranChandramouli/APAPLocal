* @ValidationCode : MjotMTM2OTkyNzMwMjpDcDEyNTI6MTY4MjA3NTEyNDM0ODpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:35:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
    AA.ID = COMI
    CALL APAP.AA.REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ID,OUT.RECORD) ;*Manual R22 conversion
    R.AA.INTEREST.APP         = FIELD(OUT.RECORD,"*",7)
    Y.RATE= R.AA.INTEREST.APP<AA.INT.FIXED.RATE,1>
    COMI = Y.RATE
END
