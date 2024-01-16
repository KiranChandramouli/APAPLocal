* @ValidationCode : Mjo1MzE2MDM4OTg6Q3AxMjUyOjE2ODQyMjI4MTQzODc6SVRTUzotMTotMTozOTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 390
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.REDO.DIRECT.DEBIT.ACCOUNTS(Y.INFO)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.REDO.DIRECT.DEBIT.ACCOUNTS
* Date           : 2018-12-11
* Item ID        : CN009818
*========================================================================
* Brief description :
* -------------------
* This a program search info in several table in order to return an array
* to ENQ no file.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-12-11     Richard HC         Initial Development
* 21-APR-2023   Conversion tool      R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V          R22 Manual Conversion    No Changes
*========================================================================
* Content summary :
* =================
* Table name     : FBNK.AA.ARRANGEMENT | FBNK.CUSTOMER |
* Auto Increment : N/A
* Views/versions : (ENQ)LAPAP.REDO.DIRECT.DEBIT.ACCOUNTS
* EB record      : N/A
* Others object  : (SS)NOFILE.REDO.DIRECT.DEBIT.ACCOUNTS
*========================================================================



    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT ;*R22 Auto conversion - END

*----------------*
* OPENING TABLES *
*----------------*

    FN.AA = "F.AA.ARRANGEMENT"
    F.AA = ""
    CALL OPF(FN.AA,F.AA)

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

*------------------------------------------*
* SEARCHING THE VALUE TO RESEARCH FROM ENQ *
*------------------------------------------*

    LOCATE "ACC" IN D.FIELDS<1> SETTING CUS.POS THEN
        ID = D.RANGE.AND.VALUE<CUS.POS>
    END

*--------------------------------------*
* SEARCHING RECORDS, IMPLEMENTIG LOGIC *
*--------------------------------------*

    SEL.CMD = "SELECT FBNK.REDO.DIRECT.DEBIT.ACCOUNTS @ID F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 WITH @ID EQ ":ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    REMOVE ACC.ID FROM SEL.LIST SETTING CR.POS

    IF ID NE ACC.ID THEN
        TEXT = "NO EXITE ESTE NUMERO DE CUENTA EN FBNK.REDO.DIRECT.DEBIT.ACCOUNTS"
        CALL STORE.END.ERROR
    END ELSE

        FF = DCOUNT(SEL.LIST,@FM)
        FOR A = 2 TO FF STEP 1

*--------------------------------------------*
* FILLING VARIABLES AND ARRAY TO BE RESOLVED *
*--------------------------------------------*

            CALL F.READ(FN.AA,SEL.LIST<A>,R.AA,F.AA,ERRA)
            AA.ACC = R.AA<AA.ARR.LINKED.APPL.ID>
            AA.CUS =  R.AA<AA.ARR.CUSTOMER>

            CALL F.READ(FN.CUS,AA.CUS,R.CUS,F.CUS,ERRC)
            NAME = R.CUS<EB.CUS.SHORT.NAME>
*CRT AA.ACC:" ":SEL.LIST<A>:" ":AA.CUS:" ":NAME

            Y.INFO<-1> = AA.ACC:"*":SEL.LIST<A>:"*":AA.CUS:"*":NAME

        NEXT A
    END


END
