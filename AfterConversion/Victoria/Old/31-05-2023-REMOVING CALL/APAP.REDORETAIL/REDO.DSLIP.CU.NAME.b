* @ValidationCode : MjotNzU0ODQ3NzY3OkNwMTI1MjoxNjgxOTA1NjgxNjUzOklUU1M6LTE6LTE6MTk1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DSLIP.CU.NAME(DS.CRR1)
*------------------------------------------------------------------------------------------------------
* DESCRIPTION:
* Deal slip routine for displaying Customer Name in TT.FXSN.SLIP deal slip
*------------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : DS.CRR1
* OUT    : DS.CRR1
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.DSF.FXSN
* LINKED WITH  : TT.FXSN.SLIP Deal slip
* ----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO                  REFERENCE          DESCRIPTION
* 27.05.2010      A C Rajkumar        ODR-2010-01-0213     INITIAL CREATION
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FOREX.SEQ.NUM
*
    FN.REDO.FOREX.SEQ.NUM = "F.REDO.FOREX.SEQ.NUM"
    F.REDO.FOREX.SEQ.NUM  = ""
    CALL OPF(FN.REDO.FOREX.SEQ.NUM, F.REDO.FOREX.SEQ.NUM)
*
    SEL.CMD.SESSION = "SELECT ":FN.REDO.FOREX.SEQ.NUM:" WITH FX.TXN.ID EQ ":DS.CRR1
    CALL EB.READLIST(SEL.CMD.SESSION,Y.FXSN.ID,'',NO.OF.SESSION.REC,SEL.ERR.SESSION)
*
    CALL F.READ(FN.REDO.FOREX.SEQ.NUM, Y.FXSN.ID, R.REC.REDO.FOREX.SEQ.NUM, F.REDO.FOREX.SEQ.NUM, Y.ERR.REDO.FOREX.SEQ.NUM)
*
    Y.CUSTOMER.NAME   = R.REC.REDO.FOREX.SEQ.NUM<REDO.FXSN.CUSTOMER.NAME>
*
    DS.CRR1 = Y.CUSTOMER.NAME
*
RETURN
END
