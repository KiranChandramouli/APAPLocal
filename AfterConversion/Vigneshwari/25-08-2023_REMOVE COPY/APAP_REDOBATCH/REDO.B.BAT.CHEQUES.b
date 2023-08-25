* @ValidationCode : MjoxMjY3ODk5ODg3OkNwMTI1MjoxNjkyODgxODA2ODU1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Aug 2023 18:26:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BAT.CHEQUES(Y.CLR.OUTWARD.ID1)
*------------------------------------------------------------------------------------------------------
* DESCRIPTION: This batch routine is to be attached to the BATCH REDO.BAT.CHEQUES for
* moving REDO.H.CLEARING.OUTWARD records from LIVE to HIS, once it was copied to records
* to REDO.H.BAT.CHQ.DETAILS
*------------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : Y.CLR.OUTWARD.ID1
* OUT    : -NA-
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.B.BAT.CHEQUES
*----------------------------------------------------------
* Modification History :
*-----------------------
* DATE            WHO              REFERENCE        DESCRIPTION
* 19.05.2010      NATCHIMUTHU.P    ODR-2010-02-0001  INITIAL CREATION
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CLEARING.OUTWARD
    $INSERT I_F.TELLER
    $INSERT I_REDO.B.BAT.CHEQUES.COMMON
    $INSERT I_F.LOCKING

    LOCK.FLUSH=''
    LOCK.ERR = ''
    CALL F.READ(FN.REDO.H.CLEARING.OUTWARD,Y.CLR.OUTWARD.ID1,R.CHQ.REC,F.REDO.H.CLEARING.OUTWARD,CHEQ.ERR)
    R.CHQ.REC<REDO.CLR.OUT.TRANSFER>='COMPLETE'
    CALL F.WRITE(FN.REDO.H.CLEARING.OUTWARD,Y.CLR.OUTWARD.ID1,R.CHQ.REC)
    SEL =  "COPY FROM ":FN.REDO.H.CLEARING.OUTWARD:" TO ":FN.REDO.H.CLEARING.OUTWARD$HIS:" ":Y.CLR.OUTWARD.ID1:" DELETING "
    EXECUTE SEL
 
    ID.LOCK = 'REDO.H.BAT.CHQ.DETAILS'
    CALL F.READ(FN.LOCKING,ID.LOCK,R.LOCKING,FV.LOCKING,LOCK.ERR)
    Y.RESET = '0000000000'
    R.LOCKING<EB.LOK.CONTENT> = Y.RESET
    CALL F.WRITE(FN.LOCKING,ID.LOCK,R.LOCKING)
    WRITE R.LOCKING TO FN.LOCKING,ID.LOCK ON ERROR
        RETURN
    END
