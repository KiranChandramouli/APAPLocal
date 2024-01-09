* @ValidationCode : MjoxOTg2OTQ0MTM1OkNwMTI1MjoxNjg0ODM2MDU0ODMzOklUU1M6LTE6LTE6LTI0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -24
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.REASN.MVMT.M
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.REASN.MVMT.M
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the REASON FOR MOVEMENT
*                    is 'OTHERS', make REMARK as mandatory
*Linked With       : COLLATERAL,DOC.MOVEMENT
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 02/06/2010        Rashmitha M         ODR-2009-10-0310 B.180C      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,SM to @SM,++ to +=
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FIND.MULTI.LOCAL.REF

    Y.CHECK = R.NEW(COLL.LOCAL.REF)<1,Y.LOC.MVMT.TYPE>
    Y.CHECK1 = R.NEW(COLL.LOCAL.REF)<1,Y.LOC.REASN.MVMT.POS>
    Y.CHECK2 = R.NEW(COLL.LOCAL.REF)<1,Y.LOC.MVMT.TYPE>
    CHANGE @SM TO ' ' IN Y.CHECK2
    CHANGE @SM TO @FM IN Y.CHECK
    CHANGE @SM TO @FM IN Y.CHECK1
    IF NOT(Y.CHECK2)  THEN
        AF = COLL.LOCAL.REF
        AV = Y.LOC.MVMT.TYPE
        AS = 1
        ETEXT = 'CO-MANDATORY.TYPE.MVMT'
        CALL STORE.END.ERROR
        RETURN
    END
    Y.COUNT =DCOUNT(Y.CHECK,@FM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        IF Y.CHECK<Y.CNT> EQ '' AND Y.CHECK1<Y.CNT> NE '' THEN
            AF = COLL.LOCAL.REF
            AV = Y.LOC.MVMT.TYPE
            AS = Y.CNT
            ETEXT = 'CO-MANDATORY.TYPE.MVMT'
            CALL STORE.END.ERROR
            RETURN
        END
        IF Y.CHECK<Y.CNT> AND Y.CHECK1<Y.CNT> EQ '' THEN
*        IF R.NEW(COLL.LOCAL.REF)<1,Y.LOC.MVMT.TYPE> AND COMI EQ '' THEN
            AF = COLL.LOCAL.REF
            AV = Y.LOC.REASN.MVMT.POS
            AS = Y.CNT
            ETEXT = 'CO-MANDATORY.REASN.MVMT'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.REASN.MVMT':@VM:'L.CO.MVMT.TYPE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    Y.LOC.REASN.MVMT.POS    = FLD.POS<1,1>
    Y.LOC.MVMT.TYPE         = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
