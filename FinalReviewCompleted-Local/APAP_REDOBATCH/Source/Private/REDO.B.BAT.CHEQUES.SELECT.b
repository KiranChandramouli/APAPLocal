* @ValidationCode : MjoyMDI1MTM2MDcyOkNwMTI1MjoxNjgxMTExODkxMjU5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BAT.CHEQUES.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION: This is SELECT routine for the BATCH routine REDO.B.BAT.CHEQUES
*-------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.B.BAT.CHEQUES.SELECT
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE                WHO               REFERENCE         DESCRIPTION
*19.05.2010      NATCHIMUTHU.P    ODR-2010-02-0001   INITIAL CREATION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CLEARING.OUTWARD
    $INSERT I_F.TELLER
    $INSERT I_F.LOCKING
    $INSERT I_REDO.B.BAT.CHEQUES.COMMON

    SEL.CMD="SELECT ":FN.REDO.H.CLEARING.OUTWARD:" WITH TRANSFER EQ READY"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
