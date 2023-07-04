* @ValidationCode : MjoxNTAwNzg5MDM1OkNwMTI1MjoxNjgwNjkwNDU5OTM4OklUU1M6LTE6LTE6NTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 500
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MOVE.PART.PAY.HIST.LOAD
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.B.MOVE.PART.PAY.HIST.LOAD
*----------------------------------------------------------


* DESCRIPTION : This routine is a load routine used to load the files used
*
*
*------------------------------------------------------------

*    LINKED WITH : REDO.B.MOVE.PART.PAY.HIST.SELECT AND REDO.B.MOVE.PART.PAY.HIST
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.05.2010      GANESH            ODR-2010-08-0017       INITIAL CREATION
* 04-APR-2023    Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.H.PART.PAY.TT
    $INSERT I_F.REDO.H.PART.PAY.FT
    $INSERT I_REDO.B.MOVE.PART.PAY.HIST.COMMON

    FN.REDO.H.PART.PAY.TT = 'F.REDO.H.PART.PAY.TT'
    F.REDO.H.PART.PAY.TT = ''
    CALL OPF(FN.REDO.H.PART.PAY.TT,F.REDO.H.PART.PAY.TT)

    FN.REDO.H.PART.PAY.FT = 'F.REDO.H.PART.PAY.FT'
    F.REDO.H.PART.PAY.FT = ''
    CALL OPF(FN.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT)

    FN.REDO.H.PART.PAY.TT.HIS = 'F.REDO.H.PART.PAY.TT$HIS'
    F.REDO.H.PART.PAY.TT.HIS = ''
    CALL OPF(FN.REDO.H.PART.PAY.TT.HIS,F.REDO.H.PART.PAY.TT.HIS)

    FN.REDO.H.PART.PAY.FT.HIS = 'F.REDO.H.PART.PAY.FT$HIS'
    F.REDO.H.PART.PAY.FT.HIS = ''
    CALL OPF(FN.REDO.H.PART.PAY.FT.HIS,F.REDO.H.PART.PAY.FT.HIS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

RETURN
END
