* @ValidationCode : MjotMTY4NTg4NTE0NjpDcDEyNTI6MTY4MjY5MTUxMjU5NjpJVFNTOi0xOi0xOjM3MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 372
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.FR.CLAIM.DOC.RECEIVED
*---------------------------------------------------------------------------------
*This is an input routine for the version REDO.FRONT.CLAIMS,NEW. It will change
*the next next version based on DOC.RECEIVED
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : Pradeep S
* Program Name  : REDO.V.INP.FR.CLAIM.DOC.RECEIVED
* ODR NUMBER    :
* HD Reference  : PACS00071941
* LINKED WITH   : REDO.FRONT.CLAIMS
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
* Date              Name                    Reference                      Description
* 27-05-2011        Pradeep S             PACS00071941                   Initial Creation
*11-04-2023         Conversion Tool        R22 Auto Code conversion          FM TO @FM
*11-04-2023          Samaran T             R22 Manual Code conversion     CALL routine format modified
*----------------------------------------------------------------------------------

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.FRONT.CLAIMS   ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.REDOSRTN

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

OPEN.FILES:
************

    FN.CUS.ACCT = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACCT = ''
    CALL OPF(FN.CUS.ACCT,F.CUS.ACCT)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

RETURN

PROCESS:
*********

    Y.DOC.NAME     = R.NEW(FR.CL.DOC.NAME)
    Y.DOC.RECEIVED = R.NEW(FR.CL.DOC.REV)
    IF Y.DOC.NAME THEN
        GOSUB CHECK.DOCS.REV
        GOSUB CHECK.DOCS
    END

    Y.CUST.NO = R.NEW(FR.CL.CUSTOMER.CODE)
    CUST.ID = Y.CUST.NO
    CUST.NO = ''
    CUST.ERR = ''
    CALL APAP.REDOSRTN.redoSCustIdVal(CUST.ID,CUST.NO,CUST.ERR) ;*R22 Manual Code conversion
    Y.CUST.NO = CUST.NO
    Y.ACCT.NO = R.NEW(FR.CL.ACCOUNT.ID)
    Y.CARD.NO = R.NEW(FR.CL.CARD.NO)

    IF Y.ACCT.NO THEN
        R.CUS.ACCT = ''
        CALL F.READ(FN.CUS.ACCT,Y.CUST.NO,R.CUS.ACCT,F.CUS.ACCT,CUS.ERR)
        CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUST.NO,R.JOIN.CUS,F.JOINT.CONTRACTS.XREF,ERR.JOIN)
        R.CUST.ACCOUNT = R.CUS.ACCT:@FM:R.JOIN.CUS
        LOCATE Y.ACCT.NO IN R.CUST.ACCOUNT SETTING ACC.POS ELSE
            AF = FR.CL.ACCOUNT.ID
            ETEXT = 'EB-NO.CUST.ACCT'
            CALL STORE.END.ERROR
        END
    END
RETURN

*--------------------------------------------------------
CHECK.DOCS.REV:
*--------------------------------------------------------

    LOCATE "" IN Y.DOC.RECEIVED<1,1> SETTING REV.POS THEN
        AF = FR.CL.DOC.REV
        AV = REV.POS
        ETEXT = 'EB-MAND.INP'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------
CHECK.DOCS:
*--------------------------------------------------------
    LOCATE 'NO' IN Y.DOC.RECEIVED<1,1> SETTING DOC.POS THEN
        R.VERSION(EB.VER.NEXT.VERSION) = ''
        R.NEW(FR.CL.STATUS)='DOCUMENT.PENDING'
    END ELSE
        R.NEW(FR.CL.STATUS)=''
    END
RETURN
*--------------
END
