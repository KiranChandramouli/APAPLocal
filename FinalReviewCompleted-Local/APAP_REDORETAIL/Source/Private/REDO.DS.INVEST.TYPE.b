* @ValidationCode : MjoyMTM2NDAwMjIyOkNwMTI1MjoxNjgxOTA1NjgwMTQ3OklUU1M6LTE6LTE6MjgxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 281
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.INVEST.TYPE(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.INVEST.TYPE
* ODR NO      : PACS00051213
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the SUB.ASSET.TYPE

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FREAD TO CACHEREAD, VM TO @VM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SUB.ASSET.TYPE

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''

    FN.SUB.ASSET.TYPE = 'F.SUB.ASSET.TYPE'
    F.SUB.ASSET.TYPE = ''

RETURN

OPENFILES:
**********
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
    CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)
RETURN

PROCESS:
********

    SEC.TRADE.ID = Y.RET

    SEC.CODE.ID = R.NEW(SC.SBS.SECURITY.CODE)

    CALL F.READ(FN.SECURITY.MASTER,SEC.CODE.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    Y.SUB.ASSET.TYPE = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>

    IF Y.SUB.ASSET.TYPE THEN
        R.SAT = '' ; SAT.ERR = ''
        CALL CACHE.READ(FN.SUB.ASSET.TYPE, Y.SUB.ASSET.TYPE, R.SAT, SAT.ERR) ;* AUTO R22 CODE CONVERSION
        Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION>
        Y.INT.CNT=DCOUNT(Y.INVERST.TYPE,@VM)

        IF Y.INT.CNT GT 1 THEN
            Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION,LNGG>
        END
        IF  Y.INVERST.TYPE EQ '' THEN
            Y.INVERST.TYPE = R.SAT<SC.CSG.DESCRIPTION,2>
        END
    END

    Y.RET = Y.INVERST.TYPE
RETURN

END
