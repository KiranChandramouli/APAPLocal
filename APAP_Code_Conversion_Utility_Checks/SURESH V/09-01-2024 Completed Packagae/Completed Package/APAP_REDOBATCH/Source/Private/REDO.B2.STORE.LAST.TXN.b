* @ValidationCode : MjotNjY1OTc1OTQ0OkNwMTI1MjoxNjgwNzkwMTEwNDU4OklUU1M6LTE6LTE6MzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B2.STORE.LAST.TXN
*****************************************
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool   R22 Auto conversion         VM to @VM
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.B2.RECORD.INS.PAY


    FN.REDO.B2.RECORD.INS.PAY = 'F.REDO.B2.RECORD.INS.PAY'
    F.REDO.B2.RECORD.INS.PAY = ''
    CALL OPF(FN.REDO.B2.RECORD.INS.PAY,F.REDO.B2.RECORD.INS.PAY)

    POSS = ''
    Y.APL = 'FUNDS.TRANSFER'
    Y.FILDS = "INS.POLICY.TYPE": @VM :"INS.COMPANY": @VM :"CLOSE.BAL.DATE": @VM : "L.FT.CONCEPT"
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FILDS,POSS)
    Y.POL.POS = POSS<1,1>
    Y.COMP.POS = POSS<1,2>
    Y.DA.POS = POSS<1,3>
    Y.CLSPOS = POSS<1,4>

    Y.POL = R.NEW(FT.LOCAL.REF)<1,Y.POL.POS>
    Y.CLS = R.NEW(FT.LOCAL.REF)<1,Y.CLSPOS>
    Y.COMP = R.NEW(FT.LOCAL.REF)<1,Y.COMP.POS>
    Y.DATE = R.NEW(FT.LOCAL.REF)<1,Y.DA.POS>



    Y.ID = Y.POL:'*':Y.CLS:'*':Y.COMP

    CALL F.READU(FN.REDO.B2.RECORD.INS.PAY,Y.ID,R.REDO.B2.RECORD.INS.PAY,F.REDO.B2.RECORD.INS.PAY,GRP.ERR,Y.RET)
    IF R.REDO.B2.RECORD.INS.PAY THEN
        LOCATE Y.DATE IN R.REDO.B2.RECORD.INS.PAY<REC.INS.DATES,1> SETTING POS.DATE THEN
            R.REDO.B2.RECORD.INS.PAY<REC.INS.FT.IDS,POS.DATE,-1> = ID.NEW
        END ELSE
            R.REDO.B2.RECORD.INS.PAY<REC.INS.DATES,-1> = Y.DATE
        END
    END ELSE
        R.REDO.B2.RECORD.INS.PAY<REC.INS.FT.IDS> = ID.NEW
        R.REDO.B2.RECORD.INS.PAY<REC.INS.DATES> = Y.DATE
    END

    CALL F.WRITE(FN.REDO.B2.RECORD.INS.PAY,Y.ID,R.REDO.B2.RECORD.INS.PAY)

    R.NEW(FT.LOCAL.REF)<1,Y.CLSPOS> = ''

RETURN

END
