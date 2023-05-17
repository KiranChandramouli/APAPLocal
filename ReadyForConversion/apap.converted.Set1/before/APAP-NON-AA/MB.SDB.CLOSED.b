*-----------------------------------------------------------------------------
* <Rating>1555</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.CLOSED

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.MB.SDB.MAINT

*************************************************************************

    GOSUB INITIALISE          ;* Special Initialising

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL MESSAGE = 'RET' DO

        V$ERROR = ''

        IF MESSAGE = 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE = 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB PROCESS.DISPLAY       ;* For Display applications

        END

MAIN.REPEAT:
    REPEAT

    V$EXIT:
    RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************

PROCESS.DISPLAY:

* Display the record fields.

    IF SCREEN.MODE EQ 'MULTI' THEN
        CALL FIELD.MULTI.DISPLAY
    END ELSE
        CALL FIELD.DISPLAY
    END

    RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************

CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.


    RETURN


*************************************************************************

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E ='EB.RTN.FUNT.NOT.ALLOWED.APP.17'
        CALL ERR
        V$FUNCTION = ''
    END

    RETURN

*************************************************************************

INITIALISE:
*
* Define often used checkfile variables
*
    CHK.ACCOUNT = "ACCOUNT":FM:AC.SHORT.TITLE:FM:"L"
    CHK.CUSTOMER = "CUSTOMER":FM:EB.CUS.SHORT.NAME:FM:'.A'


    RETURN

*************************************************************************

DEFINE.PARAMETERS:  * SEE 'I_RULES' FOR DESCRIPTIONS *


    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    ID.F = "MB.SDB.CLOSED" ; ID.N = "50" ; ID.T = "A"
*
    Z=0
*
    Z+=1 ; F(Z) = "CUSTOMER.NO" ; N(Z) = "10" ; T(Z) = ""
    Z+=1 ; F(Z) = "STATUS" ; N(Z) = "20" ; T(Z) = "N"; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "XX<JOINT.HOLDER" ; N(Z)="10"; T(Z) = ""
    CHECKFILE(Z) = "CUSTOMER":FM:EB.CUS.SHORT.NAME:FM:'L'
    Z+=1 ; F(Z) = "XX-RELATION.CODE" ; N(Z)="3"; T(Z) = ""
    CHECKFILE(Z) = "RELATION":FM:EB.REL.DESCRIPTION:FM:'L'
    Z+=1 ; F(Z) = "XX>XX.JOINT.NOTES" ; N(Z)="35"; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.KEY.NUMBERS" ; N(Z) = "10" ; T(Z) = ""; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "OPENING.DATE" ; N(Z) = "11" ; T(Z) = "D"
    Z+=1 ; F(Z) = "RENEW.METHOD" ; N(Z) = "10" ; T(Z) = "A"
    Z+=1 ; F(Z) = "CUSTOMER.ACCT" ; N(Z) = "16" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX.NOTES" ; N(Z) = "60" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.ADD.ACCESS.CUST" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "RENEWAL.DUE.ON" ; N(Z) = "19" ; T(Z) = "D"
    Z+=1 ; F(Z) = "STO.REF" ; N(Z) = "19" ; T(Z) = "A"
    Z+=1 ; F(Z) = "AMORT.Y.N" ; N(Z) = "1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "HOLDER.NAME" ; N(Z) = "55" ; T(Z) = "A"
    Z+=1 ; F(Z) = "DEPOSIT.ACCT" ; N(Z) = "16" ; T(Z) = ""
    Z+=1 ; F(Z) = "LAST.RENEWAL.DATE" ; N(Z) = "11" ; T(Z) = "D"
    Z+=1 ; F(Z) = "PERIODIC.RENT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "DISCOUNT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "VAT.AMOUNT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "DEPOSIT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "INITIAL.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "VAT.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "OFFER.EXPIRY.DATE" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "D"
    Z+=1 ; F(Z) = "TOTAL.CHARGE.AMT" ; N(Z) = "19" ; T(Z) = "N"; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "RENEW.FREQUENCY" ; N(Z) = "19" ; T(Z) = "N"; T(Z)<1> = "FQU"
    Z+=1 ; F(Z) = "AMORT.AMT" ; N(Z) = "19" ; T(Z) = "N"; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "UNAMORT.AMT" ; N(Z) = "19" ; T(Z) = "N"; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "RENT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "RENT.VAT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "MAINT.ACTION" ; N(Z) = "2" ; T(Z) = ""; T(Z)<1> = "A"
    CHECKFILE(Z) = "MB.SDB.MAINT":FM:SDB.MNT.DESCRIPTION:FM:'L'

    Z+=1 ; F(Z) = "XX<CHG.TXN.REF" ; N(Z) = "26" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-CHG.PERIODIC.RENT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.DISCOUNT.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.VAT.AMOUNT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.DEPOSIT.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.INITIAL.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.VAT.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.TOTAL.CHARGE.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.REFUND.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.PAY.REASON" ; N(Z) = "25" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-CHG.RENT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "XX>CHG.RENT.VAT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"

    Z+=1 ; F(Z) = "XX<ACS.TXN.REF" ; N(Z) = "14" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-ACS.ACCESS.NAME" ; N(Z) = "55" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-ACS.ACCESS.DATE" ; N(Z) = "8" ; T(Z) = "D"
    Z+=1 ; F(Z) = "XX-ACS.ACCESS.TIME" ; N(Z) = "5" ; T(Z) = "" ; T(Z)<4> = "R##:##"
    Z+=1 ; F(Z) = "XX>ACS.ACCESS.SLIP.NO" ; N(Z) = "15" ; T(Z) = "A"

    Z+=1 ; F(Z) = "CLOSED.ON" ; N(Z) = "8" ; T(Z) = "D"
    Z+=1 ; F(Z) = "NO.OF.SIGNERS" ; N(Z) = "2" ; T(Z) = ""

*
REM > CHECKFILE(Z) = CHK.ACCOUNT
*

*
* Live files DO NOT require V = Z + 9 as there are not audit fields.
* But it does require V to be set to the number of fields
*

    V = Z

    RETURN

*************************************************************************

END

