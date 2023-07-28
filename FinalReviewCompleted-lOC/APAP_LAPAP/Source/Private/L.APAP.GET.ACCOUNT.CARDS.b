* @ValidationCode : MjoxNDYwNDAzMDYzOkNwMTI1MjoxNjgyMzMxMzIyNTA3OklUU1M6LTE6LTE6OTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 97
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.ACCOUNT.CARDS(ENQ.DATA)
*--------------------------------------------------------------------------------------------------
* Description           : Esta rutina para optener visa debitos de una cuenta
* Developed On          : 14/09/2019
* Developed By          : Anthony Martinez
* Development Reference : APAPPMOVIL
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               14/09/2019            Creation
*
* 21-APR-2023    	 Conversion tool    		R22 Auto conversion    I to I.VAR, ++ to I.VAR BP Removed in insert file
* 21-APR-2023        Harishvikram C       Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.ORDER ;*R22 Auto conversion - END

    Y.ACCOUNT = ""

    LOCATE "ACCOUNT" IN D.FIELDS SETTING ACCOUNT.POS THEN
        Y.ACCOUNT = D.RANGE.AND.VALUE<ACCOUNT.POS>
    END

*-- GET ACCOUNT DATA
    HIS.REC1    = ''
    YERROR1     = ''
    FN.AC.HIS1  = 'F.ACCOUNT$HIS' ; F.AC.HIS1 = ''

    CALL OPF(FN.AC.HIS1, F.AC.HIS1)
    CALL EB.READ.HISTORY.REC(F.AC.HIS1, Y.ACCOUNT, HIST.REC1, YERROR1)
    Y.INDEX.CARD = 0

    FOR I.VAR = 1 TO 5 1

        Y.INDEX.CARD += 1

        IF LEN(HIST.REC1<AC.ALT.ACCT.ID, Y.INDEX.CARD>) EQ 16 THEN
            IF Y.CARDS.NUMBER THEN
                Y.CARDS.NUMBER = Y.CARDS.NUMBER : " OR @ID LIKE ...": HIST.REC1<AC.ALT.ACCT.ID, Y.INDEX.CARD>
            END ELSE
                Y.CARDS.NUMBER = "@ID LIKE ...": HIST.REC1<AC.ALT.ACCT.ID, Y.INDEX.CARD>
            END
        END

    NEXT I.VAR

*--PARA EJECUTAR QUERY
    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""; CARD.LIST.POS = ""
    SEL.CMD = "SELECT F.LATAM.CARD.ORDER WITH (" : Y.CARDS.NUMBER : ") AND CARD.STATUS EQ 94 74"

*--EJECUTAMOS LA CONSULTA A LA TABLA DE FBNK.CUS.BEN.LIST
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.CARD.ID FROM SEL.LIST SETTING CARD.LIST.POS

    WHILE Y.CARD.ID DO

        Y.CARD = Y.CARD.ID
        ENQ.DATA<-1> = SUBSTRINGS(Y.CARD, 6, 16)

    REPEAT

RETURN
