* @ValidationCode : MjoyMDMyNDYzMzEyOkNwMTI1MjoxNjgxMTMyNzcxMDQxOklUU1M6LTE6LTE6MzQwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 18:49:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 340
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE CHECK.ASSOCIATED.LOAN
* ====================================================================================
*
*    -CHECK IF THE ASSOCIATED.LOAN.ID DOESNT HAVE OTHER INSURANCE POLICY WITH THE SAME TYPE
*
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
* ASSOCIATED.LOAN.ID
* POL.TYPE
*
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Jorge Valarezo
* Date            : 06 JUL 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.APAP.AA.INSURANCE
*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN


*
* =========
INITIALISE:
* =========
*
    CURR.NO         =  0
    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1

    FN.INS.DET      =  'F.APAP.H.INSURANCE.DETAILS'
    F.INS.DET       =  ''
    R.INS.DET       =  ''

    SEL.CMD         =  ''
    SEL.LIST        =  ''
    NO.OF.REC       =  0
    ITR             =  0
    POSSITION       =  0

    RET.CODE        =  ''
    Y.APP.ERR       =  ''
    FIELD.LOAN      =  'ASSOCIATED.LOAN'
    NO.OF.LOAN      =  0
    FIELD.TYPE      =  'INS.POLICY.TYPE'
    POL.TYPE        =  ''
    FIELD.CLASS     =  'CLASS.POLICY'
    CLASS.POL       =  ''
    FIELD.NUM       =  'POLICY.NUMBER'
    ASSOCIATED.LOAN =  ''
    LOAN.ID         =  ''
    NO.OF.LOANS     =  0

*********
    FN.APAP.AA.INSURANCE='F.APAP.AA.INSURANCE'
    F.APAP.AA.INSURANCE=''
    R.APAP.AA.INSURANCE=''


RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.INS.DET,F.INS.DET)
*****
    CALL OPF(FN.APAP.AA.INSURANCE,F.APAP.AA.INSURANCE)
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1


        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* ======
PROCESS:
* ======
    POL.TYPE = R.NEW(INS.DET.INS.POLICY.TYPE)
    CLASS.POL= R.NEW(INS.DET.CLASS.POLICY)
    ASSOCIATED.LOAN = R.NEW(INS.DET.ASSOCIATED.LOAN)
    NO.OF.LOANS = DCOUNT(ASSOCIATED.LOAN,@VM)
    FOR POSSITION = 1 TO NO.OF.LOANS
        LOAN.ID = ASSOCIATED.LOAN<1,POSSITION>
        GOSUB READ.CONCAT
    NEXT POSSITION
RETURN
*=============
READ.CONCAT:
*=============

    CALL F.READ(FN.APAP.AA.INSURANCE,LOAN.ID,R.APAP.AA.INSURANCE,F.APAP.AA.INSURANCE,Y.ERR)
    ITR = 1
    NUM.INS = DCOUNT(R.APAP.AA.INSURANCE<AA.INS.INSURANCE.ID>,@VM)
    IF NOT(R.APAP.AA.INSURANCE) THEN
        RETURN
    END
    LOOP
    WHILE ITR LE NUM.INS
        ID.INS.DET = R.APAP.AA.INSURANCE<AA.INS.INSURANCE.ID,ITR>
        GOSUB READ.INSURANCE
        ITR += 1
    REPEAT
RETURN
*===============
READ.INSURANCE:
*===============

    CALL F.READ(FN.INS.DET, ID.INS.DET, R.INS.DET, F.INS.DET, Y.APP.ERR)
    IF Y.APP.ERR THEN
        RETURN
    END
    IF R.INS.DET<INS.DET.POLICY.NUMBER> NE R.NEW(INS.DET.POLICY.NUMBER) AND R.INS.DET<INS.DET.INS.POLICY.TYPE> EQ POL.TYPE AND R.INS.DET<INS.DET.CLASS.POLICY> EQ CLASS.POL THEN
        GOSUB THROW.OVERRIDE
    END
RETURN

*===============
THROW.OVERRIDE:
*===============

    TEXT="APAP.ASSOCIATED.LOAN.OVERRIDE":@FM:LOAN.ID
    CURR.NO = DCOUNT(R.NEW(INS.DET.OVERRIDE),@VM) + 1
    CALL STORE.OVERRIDE(CURR.NO)
RETURN

END
