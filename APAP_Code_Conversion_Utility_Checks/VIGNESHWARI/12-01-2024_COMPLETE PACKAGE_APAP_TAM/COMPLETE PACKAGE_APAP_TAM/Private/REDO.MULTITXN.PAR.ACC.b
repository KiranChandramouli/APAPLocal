* @ValidationCode : MjoxNjg1ODgwMDMyOlVURi04OjE3MDQ5NTU4NzQ0MjA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 12:21:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.MULTITXN.PAR.ACC (DATA.OUT)
*
* ====================================================================================
*
*    - Subroutine for Nofine Enquiry: REDO.MULTITXN.PAR.ACC
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

*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : pgarzongavilanes
* Development by  :
* Date            : 2011-04-06
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, I TO I.VAR
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
* 11.01.2024       Narmadha V            R22            Manual R22 Conversion   F.READ to CACHE.READ
*------------------------------------------------------------------------------------------------------

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB EXTRACT.DATA
*
RETURN

* =========
INITIALISE:
* =========
*
    FN.PAR='F.REDO.MULTITXN.PARAMETER'
    F.PAR=''
    R.PAR=''
    Y.PAR.ID=''
    Y.PAR.ERR=''

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    R.ACC=''
    Y.ACC.ID=''
    Y.ACC.ERR=''

    Y.POS = 0

    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.REC = 0
    Y.ERR = ''

    Y.PAR.CAT.NUEVA = ''
    Y.PAR.CAT.ACTUAL = ''

    Y.CAT.ACTUAL = ''
    Y.CAT.NUEVA = ''

    PAR.COUNT = 0

    SEL.CMD.ACC = ''
    SEL.LIST.ACC = ''
    NO.OF.REC.ACC = 0
    Y.ERR.ACC = ''

    Y.POS.ACC = 0

    Y.WOR.BAL = 0

    CAJERO.VAL = ''
    FILTRO = ''


RETURN

*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.PAR,F.PAR)

    CALL OPF(FN.ACC,F.ACC)

RETURN

* ======================
EXTRACT.DATA:
* ======================
*

    SEL.CMD  = 'SELECT ':FN.PAR

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)

    LOOP
        REMOVE Y.PAR.ID FROM SEL.LIST SETTING Y.POS
    WHILE Y.PAR.ID:Y.POS

*CALL F.READ(FN.PAR,Y.PAR.ID,R.PAR,F.PAR,Y.PAR.ERR)
        CALL CACHE.READ(FN.PAR,Y.PAR.ID,R.PAR,Y.PAR.ERR) ;*Manual R22 Conversion

***Multivalue field with all Account Category Codes for transactions.
        Y.PAR.CAT.ACTUAL = R.PAR<RMP.ACTUAL.CATEG>
        Y.PAR.CAT.NUEVA = R.PAR<RMP.NEW.CATEG>


*LEER CUENTAS
        PAR.COUNT = DCOUNT(Y.PAR.CAT.ACTUAL,@VM)

        FOR I.VAR=1 TO PAR.COUNT                            ;** R22 Auto conversion - I TO I.VAR
            Y.CAT.ACTUAL = Y.PAR.CAT.ACTUAL<1,I.VAR>        ;** R22 Auto conversion - I TO I.VAR
            Y.CAT.NUEVA = Y.PAR.CAT.NUEVA<1,I.VAR>          ;** R22 Auto conversion - I TO I.VAR

            CAJERO.VAL = D.RANGE.AND.VALUE<1>
            FILTRO = Y.CAT.NUEVA : CAJERO.VAL

            SEL.CMD.ACC =  "SELECT " : FN.ACC : " WITH CUSTOMER.NO EQ ''"

            IF CAJERO.VAL NE "" THEN
                SEL.CMD.ACC := " AND WITH @ID LIKE ..." : FILTRO : "..."
            END
            ELSE
                SEL.CMD.ACC := " AND WITH CATEGORY EQ " : Y.CAT.NUEVA
            END


            CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NO.OF.REC.ACC,Y.ERR.ACC)

            LOOP
                REMOVE Y.ACC.ID FROM SEL.LIST.ACC SETTING Y.POS.ACC
            WHILE Y.ACC.ID:Y.POS.ACC

*READ EACH ACCOUNT
                CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,F.ACC,Y.ACC.ERR)
                R.ECB='' ; ECB.ERR='' ;*Tus Start
                CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACC.ID,R.ECB,ECB.ERR)
*     Y.WOR.BAL = R.ACC<AC.WORKING.BALANCE>
                Y.WOR.BAL = R.ECB<ECB.WORKING.BALANCE>
                IF Y.WOR.BAL NE 0 AND Y.WOR.BAL NE "" AND Y.WOR.BAL NE " " THEN
*        DATA.OUT<-1> = Y.ACC.ID : "*" : R.ACC<AC.SHORT.TITLE> : "*" : R.ACC<AC.WORKING.BALANCE>
                    DATA.OUT<-1> = Y.ACC.ID : "*" : R.ACC<AC.SHORT.TITLE> : "*" : R.ECB<ECB.WORKING.BALANCE>;*Tus End

                END

            REPEAT

        NEXT I.VAR                          ;** R22 Auto conversion - I TO I.VAR

    REPEAT

RETURN

END
