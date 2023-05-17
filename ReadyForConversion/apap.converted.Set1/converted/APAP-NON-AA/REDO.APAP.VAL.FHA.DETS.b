SUBROUTINE REDO.APAP.VAL.FHA.DETS
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : JEEVA T
* Program Name  : REDO.APAP.VAL.FHA.DETS
* ODR NUMBER    : ODR-2009-10-0346
*----------------------------------------------------------------------------------
* Description   : REDO.APAP.VAL.FHA.DETS is a validation routine for the version
*                 AZ.ACCOUNT, OPEN.CPH which populates two fields FHA.POL.NO
*                 and FHA.CASE.NO
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
*------------------------------------------------------------------------------


    GOSUB OPEN
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------
********
OPEN:
********

    Y.REDO.IN.ACT.ERR=''

    FN.AA.ARR.CHARGE = 'F.AA.ARR.CHARGE'
    F.AA.ARR.CHARGE  = ''
    CALL OPF(FN.AA.ARR.CHARGE,F.AA.ARR.CHARGE)

    FN.REDO.APAP.CPH.PARAMETER = 'F.REDO.APAP.CPH.PARAMETER'
    F.REDO.APAP.CPH.PARAMETER  = ''
    CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*------------------------------------------------------------------------------
********
PROCESS:
********
    Y.MG.ACT.NO=COMI
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT) THEN
        RETURN
    END
    GOSUB READ.AA.ARR.CHARGE
    GOSUB UPD.FHA.DET
RETURN
*------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    CALL F.READ(FN.ACCOUNT,Y.MG.ACT.NO,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
    Y.ARR.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
RETURN
*------------------------------------------------------------------------------
******************
READ.AA.ARR.CHARGE:
******************

    EFF.DATE = ''
    PROP.CLASS='CHARGE'
    GOSUB READ.CPH.PARAMETER
    PROPERTY = Y.CHARGE.PROP
    AA.ID=Y.ARR.ID
    R.AA.ARR.CHARGE = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.AA.ARR.CHARGE,ERR.MSG)
RETURN
*------------------------------------------------------------------------------
*************************
READ.CPH.PARAMETER:
*************************
    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.CHARGE.PROP=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.CHARGE.PROP.NAME>
RETURN
*------------------------------------------------------------------------------

************
UPD.FHA.DET:
************
    GOSUB FIND.MULTI.LOCAL.REF


    Y.POLICY.TYPES=R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.POL.TYPE.POS>
    LOCATE 'FHA' IN Y.POLICY.TYPES<1,1,1> SETTING Y.FHA.POS THEN
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.FHA.POL.NO.POS,AS>=R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.POL.NO.POS,Y.FHA.POS>
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.FHA.CASE.NO.POS,AS>=R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.CASE.NO.POS,Y.FHA.POS>
    END ELSE
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.FHA.POL.NO.POS,AS>='N'
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.FHA.CASE.NO.POS,AS>='N'
    END
RETURN
*------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    FLD.POS=''
    APPL.ARRAY="AZ.ACCOUNT":@FM:"AA.PRD.DES.CHARGE"
    FLD.ARRAY='L.MG.ACT.NO':@VM:'L.FHA.POL.NO':@VM:'L.FHA.CASE.NO':@FM:'INS.POLICY.TYPE':@VM:'POLICY.NUMBER':@VM:'L.FHA.CASE.NO'
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MG.ACT.NO.POS=FLD.POS<1,1>
    LOC.L.FHA.POL.NO.POS=FLD.POS<1,2>
    LOC.L.FHA.CASE.NO.POS=FLD.POS<1,3>
    LOC.POL.TYPE.POS=FLD.POS<2,1>
    LOC.POL.NO.POS=FLD.POS<2,2>
    LOC.CASE.NO.POS=FLD.POS<2,3>
RETURN

*------------------------------------------------------------------------------
END
