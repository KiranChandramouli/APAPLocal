* @ValidationCode : MjotNjMxOTU3NTA3OkNwMTI1MjoxNjgxODAwODQzMzIwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:24:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.REINV.VAL.FHA.DETS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.REINV.VAL.FHA.DETS
*------------------------------------------------------------------------------

*Description  : REDO.APAP.REINV.VAL.FHA.DETS is a validation routine for the
*               version REDO.H.AZ.REINV.DEPOSIT,CPH which populates two fields
*               FHA.POL.NO and FHA.CASE.NO
*Linked With  : REDO.H.AZ.REINV.DEPOSIT,CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : AA.CHARGE,REDO.H.AZ.REINV.DEPOSIT

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 04-08-2010       JEEVA T           ODR-2009-10-0346 B.21       Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  VM to @VM
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT
    $INSERT I_F.REDO.APAP.CPH.PARAMETER

*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

*--------------------------------------------------------------------------------

**********
OPEN.PARA:
**********

    Y.REDO.IN.ACT.ERR=''

    FN.AA.ARR.CHARGE = 'F.AA.ARR.CHARGE'
    F.AA.ARR.CHARGE  = ''
    CALL OPF(FN.AA.ARR.CHARGE,F.AA.ARR.CHARGE)

    FN.ACCOUNT= 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
    F.REDO.APAP.CPH.PARAMETER=''
    CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)

RETURN
*------------------------------------------------------------------------------
**********
PROCESS.PARA:
*************
    Y.MG.ACT.NOS=COMI
    GOSUB READ.ACCOUNT
    GOSUB READ.AA.ARR.CHARGE
    GOSUB UPD.FHA.DET
RETURN
*------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    R.ACCOUNT = ''
    ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.MG.ACT.NOS,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.ARR.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
RETURN
*------------------------------------------------------------------------------
*************
READ.AA.ARR.CHARGE:
*************
    EFF.DATE = ''
    PROP.CLASS='CHARGE'
    GOSUB READ.CPH.PARAMETER
    AA.ID=Y.ARR.ID
    PROPERTY = Y.CHARGE.PROP
    R.AA.ARR.CHARGE = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.AA.ARR.CHARGE,ERR.MSG)
RETURN

*-----------------------------------------------------------------------------
*************
UPD.FHA.DET:
*************
    GOSUB FIND.MULTI.LOCAL.REF
    Y.POLICY.TYPES=R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.POL.TYPE.POS>
    LOCATE 'FHA' IN Y.POLICY.TYPES<1,1,1> SETTING Y.FHA.POS THEN
        R.NEW(REDO.AZ.REINV.FHA.POL.NO)<1,AV> = R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.POL.NO.POS,Y.FHA.POS>
        R.NEW(REDO.AZ.REINV.FHA.CASE.NO)<1,AV> = R.AA.ARR.CHARGE<AA.CHG.LOCAL.REF,LOC.CASE.NO.POS,Y.FHA.POS>
    END ELSE

        R.NEW(REDO.AZ.REINV.FHA.POL.NO)<1,AV>='N'
        R.NEW(REDO.AZ.REINV.FHA.CASE.NO)<1,AV>='N'
    END
RETURN

*-----------------------------------------------------------------------------
*******************
READ.CPH.PARAMETER:
*******************
    Y.PARA.ID='SYSTEM'
    R.REDO.APAP.CPH.PARAMETER = ''
    REDO.APAP.CPH.PARAMETER.ERR = ''
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,REDO.APAP.CPH.PARAMETER.ERR)
    Y.CHARGE.PROP=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.CHARGE.PROP.NAME>
RETURN

*-----------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    FLD.POS = ''
    APPL.ARRAY = 'AA.PRD.DES.CHARGE'
    FLD.ARRAY ='INS.POLICY.TYPE':@VM:'POLICY.NUMBER':@VM:'L.FHA.CASE.NO'

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.POL.TYPE.POS=FLD.POS<1,1>
    LOC.POL.NO.POS=FLD.POS<1,2>
    LOC.CASE.NO.POS=FLD.POS<1,3>
RETURN

*-----------------------------------------------------------------------------
END
