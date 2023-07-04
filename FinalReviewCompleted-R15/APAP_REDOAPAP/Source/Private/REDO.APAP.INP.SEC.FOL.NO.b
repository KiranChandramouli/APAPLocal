* @ValidationCode : MjotMTI2MzcwNTIwOTpDcDEyNTI6MTY4NDgzNjA0MjQzMDpJVFNTOi0xOi0xOjUzODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 538
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.SEC.FOL.NO
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.SEC.FOL.NO
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to extract the CUSOTMER number from
*                    ID.NEW and then read the file REDO.CUS.SEC.FOL.NO.DET  with the same CUSOTMER number
*                    and get the value of SEC.FOLD.NO and assign it to this field
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : REDO.CUS.SEC.FOL.NO.DET      As          I   Mode
*                    COLLATERAL                   As          I   Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 26/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.CUS.SEC.FOL.NO.DET
    $INSERT I_F.LOCKING
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.CUS.SEC.FOL.NO.DET = 'F.REDO.CUS.SEC.FOL.NO.DET'
    F.REDO.CUS.SEC.FOL.NO.DET  = ''
    CALL OPF(FN.REDO.CUS.SEC.FOL.NO.DET,F.REDO.CUS.SEC.FOL.NO.DET)

    FN.LOCKING = 'F.LOCKING'
    F.LOCKING  = ''
    CALL OPF(FN.LOCKING,F.LOCKING)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FIND.MULTI.LOCAL.REF
    REDO.CUS.SEC.FOL.NO.DET.ID = FIELD(ID.NEW,'.',1,1)

    GOSUB READ.REDO.CUS.SEC.FOL.NO.DET

    IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.FOL.NO> THEN
        R.REDO.CUS.SEC.FOL.NO.DET<CUS.SEC.CUSTOMER.NO> = REDO.CUS.SEC.FOL.NO.DET.ID
        R.REDO.CUS.SEC.FOL.NO.DET<CUS.SEC.SEC.FOLD.NO> = R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.FOL.NO>
        GOSUB WRITE.REDO.CUS.SEC.FOL.NO.DET
        RETURN
    END


    IF R.REDO.CUS.SEC.FOL.NO.DET THEN
        Y.SEC.FOLD.NUM = R.REDO.CUS.SEC.FOL.NO.DET<CUS.SEC.SEC.FOLD.NO>
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.FOL.NO> = Y.SEC.FOLD.NUM
        ETEXT = "CO-SEC.FOLD.NO":@FM:Y.SEC.FOLD.NUM
        CALL STORE.END.ERROR
        RETURN
    END


    LOCKING.ID = 'REDO.SEC.FOL.NO'
    GOSUB READ.LOCKING

    Y.LOK.CONTENT = R.LOCKING<EB.LOK.CONTENT> + 1

    R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.FOL.NO> = Y.LOK.CONTENT
    R.LOCKING<EB.LOK.CONTENT> = Y.LOK.CONTENT
    GOSUB WRITE.LOCKING

    R.REDO.CUS.SEC.FOL.NO.DET<CUS.SEC.CUSTOMER.NO> = REDO.CUS.SEC.FOL.NO.DET.ID
    R.REDO.CUS.SEC.FOL.NO.DET<CUS.SEC.SEC.FOLD.NO> = Y.LOK.CONTENT
    GOSUB WRITE.REDO.CUS.SEC.FOL.NO.DET

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.LOCKING:
*************
    R.LOCKING  = ''
    LOCKING.ER = ''
    CALL F.READU(FN.LOCKING,LOCKING.ID,R.LOCKING,F.LOCKING,LOCKING.ER,'')

RETURN
*-----------------------------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.CUS.SEC.FOL.NO.DET:
*****************************
    R.REDO.CUS.SEC.FOL.NO.DET  = ''
    REDO.CUS.SEC.FOL.NO.DET.ER = ''
    CALL F.READ(FN.REDO.CUS.SEC.FOL.NO.DET,REDO.CUS.SEC.FOL.NO.DET.ID,R.REDO.CUS.SEC.FOL.NO.DET,F.REDO.CUS.SEC.FOL.NO.DET,REDO.CUS.SEC.FOL.NO.DET.ER)

RETURN
*---------------------------------------------------------------------------------------------------------------------------
******************************
WRITE.REDO.CUS.SEC.FOL.NO.DET:
******************************
    CALL F.WRITE(FN.REDO.CUS.SEC.FOL.NO.DET,REDO.CUS.SEC.FOL.NO.DET.ID,R.REDO.CUS.SEC.FOL.NO.DET)

RETURN
*---------------------------------------------------------------------------------------------------------------------------
****************
WRITE.LOCKING:
****************
    WRITE R.LOCKING TO F.LOCKING,LOCKING.ID


RETURN
*--------------------------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.SEC.FOL.NO':@VM:'L.CO.LOC.STATUS'
    FLD.POS    = ''
    LOC.L.CO.SEC.FOL.NO=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.SEC.FOL.NO        = FLD.POS<1,1>
    LOC.L.CO.LOC.STATUS       = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
