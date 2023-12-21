* @ValidationCode : MjotMTQwMzE2NTcxMDpDcDEyNTI6MTcwMzE1ODQ4NzUyMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2023 17:04:47
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.AZ.ACCOUNT
****************************************************************
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : H GANESH
* Program Name : REDO.AUTH.AZ.ACCOUNT
*-----------------------------------------------------------------------------

* Description : This routine is to update the az.account belongs to that customer with
* balance consolidation as 'Y' then all deposit balance consilation is set as 'Y' and
* the balance consolidation as 'N' then all deposit balance consolidation is set as 'N'

* Linked with: AZ.ACCOUNT
* In parameter : None
* out parameter : None

*---------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 15/3/2011 H GANESH B.163-PACS00032518 Initial draft
* 31/8/2011 S SUDHARSANAN PACS00090249 The az.account belongs to that customer with balance
* consolidation as 'Y' then all deposit balance consilation is set as 'Y'
* and the balance consolidation as 'N' then all deposit balance consolidation is set as 'N'
*-----------------------------------------------------------------------------
*Modification History
*DATE                    WHO                      REFERENCE                           DESCRIPITION
*04-04-2023           Conversion Tool          R22 Auto Code conversion          FM TO @FM, ++ TO +=1
*04-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $USING EB.LocalReferences
*
    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.JOINT.NUM=''

    FN.AZ.CUSTOMER='F.AZ.CUSTOMER'
    F.AZ.CUSTOMER=''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    LREF.APP='AZ.ACCOUNT'
    LREF.FIELD='L.AZ.BAL.CONSOL'
    LREF.POS=''
* CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELD,LREF.POS);*R22 MANUAL CODE CONVERSION
    POS.L.AZ.BAL.CONSOL=LREF.POS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.BAL.CONSOL=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.BAL.CONSOL>
    GOSUB UPDATE.AZ.ACCOUNT
    GOSUB UPDATE.AZ.CONS.BAL
RETURN
*-----------------------------------------------------------------------------
UPDATE.AZ.ACCOUNT:
*-----------------------------------------------------------------------------
*This para is get the all the deposit for the customer
    Y.AZ.CUSTOMER.ID=R.NEW(AZ.CUSTOMER)
    R.AZ.CUSTOMER=''
    CALL F.READ(FN.AZ.CUSTOMER,Y.AZ.CUSTOMER.ID,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.AZ.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,XREF.ERR)
    NO.OF.JOINT.ACCOUNT=DCOUNT(R.JOINT.CONTRACTS.XREF,@FM) ;*R22 AUTO CODE CONVERSION
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.JOINT.ACCOUNT
        Y.ACC.NO=R.JOINT.CONTRACTS.XREF<Y.VAR1>
        CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACC,F.ACCOUNT,ACC.ERR)
        Y.JOINT.HOLD=R.ACC<AC.JOINT.HOLDER>
        LOCATE Y.AZ.CUSTOMER.ID IN Y.JOINT.HOLD<1,1> SETTING POS1 THEN
            Y.RELATION.CODE=R.ACC<AC.RELATION.CODE,POS1>
            IF (Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 509) OR (Y.RELATION.CODE GE 600 AND Y.RELATION.CODE LE 609) THEN
                R.AZ=''
                CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
                IF R.AZ NE '' THEN
                    Y.JOINT.NUM<-1>=Y.ACC.NO
                END
            END
        END
        Y.VAR1 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.AZ.IDS=R.AZ.CUSTOMER:@FM:Y.JOINT.NUM ;*R22 AUTO CODE CONVERSION
RETURN
*-------------------------------------------------------------------------------------------------------
UPDATE.AZ.CONS.BAL:
*--------------------------------------------------------------------------------------------------------
*This section is used to update the L.AZ.BAL.CONSOL based on the value present in the deposit
    IF Y.BAL.CONSOL EQ 'Y' THEN
        GOSUB UPDATE.AZ.Y
    END ELSE
        GOSUB UPDATE.AZ.N
    END
RETURN
*-----------------------------------------------------------------------------------------------------
UPDATE.AZ.Y:
*-----------------------------------------------------------------------------------------------------
*This para is update the L.AZ.BAL.CONSOL as 'Y' , if the balance consolidation is equal to 'Y'
    Y.AZ.NO=DCOUNT(Y.AZ.IDS,@FM)  ;*R22 AUTO CODE CONVERSION
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.AZ.NO
        Y.ID=Y.AZ.IDS<Y.VAR2>
        IF Y.ID EQ '' OR Y.ID EQ ID.NEW ELSE
* CALL F.READ(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)
            CALL F.READU(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR,'')
            IF (R.AZ.ACC<AZ.LOCAL.REF,POS.L.AZ.BAL.CONSOL> NE 'Y') AND (R.NEW(AZ.CURRENCY) EQ R.AZ.ACC<AZ.CURRENCY>) THEN
                R.AZ.ACC<AZ.LOCAL.REF,POS.L.AZ.BAL.CONSOL>='Y'
                CALL F.WRITE(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC)
*CALL REDO.AZ.WRITE.TRACE('REDO.AUTH.AZ.ACCOUNT',Y.ID)
            END
        END
        Y.VAR2 += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------------
UPDATE.AZ.N:
*-------------------------------------------------------------------------------------------------------------
*This para is update the L.AZ.BAL.CONSOL as 'N' , if the balance consolidation is not equal to 'Y'
    Y.AZ.NO=DCOUNT(Y.AZ.IDS,@FM)  ;*R22 AUTO CODE CONVERSION
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.AZ.NO
        Y.ID=Y.AZ.IDS<Y.VAR2>
        IF Y.ID EQ '' OR Y.ID EQ ID.NEW ELSE
*CALL F.READ(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)
            CALL F.READU(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR,'') ;*R22 MNAUAL CODE CONVERSION
            IF (R.AZ.ACC<AZ.LOCAL.REF,POS.L.AZ.BAL.CONSOL> NE 'N') AND (R.NEW(AZ.CURRENCY) EQ R.AZ.ACC<AZ.CURRENCY>) THEN
                R.AZ.ACC<AZ.LOCAL.REF,POS.L.AZ.BAL.CONSOL>='N'
                CALL F.WRITE(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACC)
*CALL REDO.AZ.WRITE.TRACE('REDO.AUTH.AZ.ACCOUNT',Y.ID)
            END
        END
        Y.VAR2 += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------------------------------------
END
