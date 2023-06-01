* @ValidationCode : MjotMTYyNTYyNTU3NzpDcDEyNTI6MTY4MjU5ODAxMDgzOTpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.SPLIT.VALIDATE.3
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.VALIDATE.3
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine called in LATAM.CARD.ORDER.VALIDATE
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION             = TO EQ
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.COMPANY
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_GTS.COMMON
*  End of core table includes
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CLASS.CODE



    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
    GOSUB CHECK.DEL

*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.CROSSVAL
    CALL APAP.REDORETAIL.latamCardOrderSplitCrossval();* MANUAL R22 CODE CONVERSION

RETURN
*---------------------------------------------------------------------
**********
INIT.PARA:
**********
*Necessary file variables are initialised and opened

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    R.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    R.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
RETURN
*-------------------------------------------------------------------
************
PROCESS.PARA:
************
* Main processing section, code is process only if function is reverse
    IF V$FUNCTION NE 'R' THEN
        RETURN
    END
    CARD.TYPE.ID = FIELD(ID.NEW,'.',1)
    CALL F.READ(FN.CARD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,CARD.TYPE.ERR)
    IF R.CARD.TYPE<CARD.TYPE.AZ.PRODUCT> EQ  '' THEN
        RETURN
    END
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING POS THEN
        AZ.ACC = RAISE(R.NEW(CARD.IS.ACCOUNT))
        LOOP
            REMOVE ACC.ID FROM AZ.ACC SETTING POS
        UNTIL ACC.ID EQ ''
            CALL F.READ(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
            IF R.AZ.ACCOUNT THEN
                ETEXT = "ST-RTN.LINKED.TO.AZ.ACC"
                CALL STORE.END.ERROR
                RETURN
            END
        REPEAT
    END
RETURN
*------------------------------------------------------------------------
*********
CHECK.DEL:
*********
    IF V$FUNCTION EQ 'D' THEN
        IF R.NEW(CARD.IS.STMT.NO) EQ 'VAL' THEN
            CALL EB.ACCOUNTING('CC','DEL','','')
        END
    END
RETURN
*-------------------------------------------------------------------------
END
