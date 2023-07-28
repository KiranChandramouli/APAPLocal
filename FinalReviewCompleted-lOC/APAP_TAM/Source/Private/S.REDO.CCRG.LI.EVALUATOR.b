* @ValidationCode : MjoxMzQ5NDU5MTg1OkNwMTI1MjoxNjg0ODQyMTU0NDQ2OklUU1M6LTE6LTE6MTY1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 165
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.LI.EVALUATOR(P.IN.CONTRACT.ID, R.IN.RCBTP, R.IN.CUSTOMER, R.IN.LI, P.OUT.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, SM TO @SM
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION      NOCHANGE, CALL routine format modified
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*  This routine decides if the REDO.CCRG.BALANCE.TYPE.PARAM contract must or not to be processed.
*  The contract must be of LIMIT application
*
*  Input Param:
*  ------------
*     P.IN.CONTRACT.ID: Arrangement Id associated to LIMIT
*     R.IN.RCBTP: REDO.BALANCE.TYPE.PARAM record
*     R.IN.CUSTOMER: CUSTOMER record
*     R.IN.LI: Arrangement record. If this record is empty needs to be read
*
*  Output Param:
*  ------------
*     P.OUT.RETURN: Returns the types of balances that have to be calculated
*        Positions:
*           2: Client list associated to the AA
*           3: Type relation betwen clients the point 2
*           4: LIMIT.REF associated
*           5: Arrangement category associated
*     E: Error message if exists
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    $INSERT I_REDO.CCRG.CONSTANT.COMMON
    $INSERT I_REDO.CCRG.B.EXT.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB  OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    PROCESS.GOAHEAD = 1
    P.OUT.RETURN<1> = ''
    E               = ''
    Y.ERR           = ''
    P.VALUES        = ''

RETURN


*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
* Open files only if not already open

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

*
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*Set Relation Code
    P.VALUES<1,1> = K.CUS.RELATION.CODE
    Y.REL.CODE    = CHANGE(R.IN.CUSTOMER<EB.CUS.RELATION.CODE>,@VM,@SM)
    P.VALUES<2,1> = Y.REL.CODE

*Set Category
    P.VALUES<1,2> = K.CATEGORY
    P.VALUES<2,2> = P.OUT.RETURN<5>

*Validade data
    P.RESULT = ''
    CALL APAP.TAM.S.REDO.CCRG.EVAL.BAL.TYP.CON(R.IN.RCBTP, P.VALUES, P.RESULT) ;*MANUAL R22 CODE CONVERSION
    P.OUT.RETURN<1> = P.RESULT<1>
    P.OUT.RETURN<5> = P.OUT.RETURN<5>
*Id not existe records en LIMIT, dont have to process.
    IF NOT(R.IN.LI) THEN
        P.OUT.RETURN<1> = @FALSE
    END
RETURN


*-----------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

* Read record with id P.IN.CONTRACT.ID
    R.IN.LI = ''
    CALL F.READ(FN.LIMIT,P.IN.CONTRACT.ID,R.IN.LI,F.LIMIT,Y.ERR)

    E = Y.ERR
    IF NOT(R.IN.LI) THEN
        PROCESS.GOAHEAD = 0
    END

RETURN

END
