* @ValidationCode : MjotMTUyMTUxODE3MTpDcDEyNTI6MTY4NDgzNjAzNDI4NTpJVFNTOi0xOi0xOjQ2OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 469
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CAMPAIGN.CREATE(CAMPAIGN.ID)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.CREATE
* ODR NUMBER    : ODR-2010-08-0228
*----------------------------------------------------------------------------------
* Description : This is a batch routine which creates the file in the o/p format
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.OPPORTUNITY
    $INSERT I_F.REDO.APAP.CAMPAIGN.PATH
    $INSERT I_REDO.APAP.CAMPAIGN.CREATE.COMMON
*
    GOSUB PROCESS
RETURN
*
PROCESS:
*--------
*
    Y.PATH.ID = 'SYSTEM'
*

*  CALL F.READ(FN.REDO.APAP.CAM.PATH,Y.PATH.ID,R.PATH.REC,F.REDO.APAP.CAM.PATH,Y.PATH.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.APAP.CAM.PATH,Y.PATH.ID,R.PATH.REC,Y.PATH.ERR) ; * Tus End
    FN.PATH  = R.PATH.REC<REDO.CAMPGN.PAT.CAMPAIGN.PATH>
    OPEN FN.PATH TO F.PATH ELSE

        ERR.MSG = "Error in opening : ":FN.PATH
        CALL DISPLAY.MESSAGE(ERR.MSG,1)
        RETURN
    END
*
    Y.CAMPAIGN.ID = CAMPAIGN.ID
*
    CALL F.READ(FN.CR.OPP,Y.CAMPAIGN.ID,R.CR.REC,F.CR.OPP,Y.CR.ERR)
    Y.CUSTOMER = R.CR.REC<CR.OP.CUSTOMER>
*
    CALL F.READ(FN.CUST,Y.CUSTOMER,R.CUSTOMER,F.CUST,Y.CUS.ERR)
*
    Y.EMAIL.1 = R.CUSTOMER<EB.CUS.EMAIL.1>
    Y.EMAIL.1 = FMT(Y.EMAIL.1,'35L')
*
    Y.TEL.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.TEL.TYPE.POS>
    IF Y.TEL.TYPE EQ '01' THEN
        Y.TEL.AREA = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.TEL.AREA.POS>
        Y.TEL.NO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.TEL.NO.POS>
    END
*
    Y.CONTACT.NO.1 = Y.TEL.AREA:Y.TEL.NO
    Y.CONTACT.NO.1 = FMT(Y.CONTACT.NO.1,'24L')
*
    Y.CONTACT.NO.2 = ''
    Y.CONTACT.NO.2 = FMT(Y.CONTACT.NO.2,'24L')
*
    Y.CONTACT.NO.3 = ''
    Y.CONTACT.NO.3 = FMT(Y.CONTACT.NO.3,'24L')
*
    Y.CONTACT.NO.4 = ''
    Y.CONTACT.NO.4 = FMT(Y.CONTACT.NO.4,'24L')
*
    Y.CONTACT.NO.5 = ''
    Y.CONTACT.NO.5 = FMT(Y.CONTACT.NO.5,'24L')
*
    Y.GIVEN.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    Y.FAMILY.NAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
*
    Y.NAME = Y.GIVEN.NAMES:" ":Y.FAMILY.NAME
    Y.NAME = FMT(Y.NAME,'50L')
*
    Y.DOB = R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>
    Y.DOB = Y.DOB[7,2]:'/':Y.DOB[5,2]:'/':Y.DOB[1,4]
    Y.DOB = FMT(Y.DOB,'10L')
*
    Y.STATUS = '1'
    Y.STATUS = FMT(Y.STATUS,'1L')
*
    Y.NULL.SPACE = ' '
*
    Y.CAMPAIGN.ID = FMT(Y.CAMPAIGN.ID,'20L')
    Y.CUSTOMER = FMT(Y.CUSTOMER,'15L')
*
    IF Y.FINAL.ARRAY THEN
        Y.FINAL.ARRAY<-1> = Y.STATUS:Y.NULL.SPACE:Y.CAMPAIGN.ID:Y.NULL.SPACE:Y.CUSTOMER:Y.NULL.SPACE:Y.EMAIL.1:Y.NULL.SPACE:Y.CONTACT.NO.1:Y.NULL.SPACE:Y.CONTACT.NO.2:Y.NULL.SPACE:Y.CONTACT.NO.3:Y.NULL.SPACE:Y.CONTACT.NO.4:Y.NULL.SPACE:Y.CONTACT.NO.5:Y.NULL.SPACE:Y.NAME:Y.NULL.SPACE:Y.DOB
    END ELSE
        Y.FINAL.ARRAY = Y.STATUS:Y.NULL.SPACE:Y.CAMPAIGN.ID:Y.NULL.SPACE:Y.CUSTOMER:Y.NULL.SPACE:Y.EMAIL.1:Y.NULL.SPACE:Y.CONTACT.NO.1:Y.NULL.SPACE:Y.CONTACT.NO.2:Y.NULL.SPACE:Y.CONTACT.NO.3:Y.NULL.SPACE:Y.CONTACT.NO.4:Y.NULL.SPACE:Y.CONTACT.NO.5:Y.NULL.SPACE:Y.NAME:Y.NULL.SPACE:Y.DOB
    END
*
    WRITE Y.FINAL.ARRAY TO F.PATH,FILE.NAME

*
RETURN
END
