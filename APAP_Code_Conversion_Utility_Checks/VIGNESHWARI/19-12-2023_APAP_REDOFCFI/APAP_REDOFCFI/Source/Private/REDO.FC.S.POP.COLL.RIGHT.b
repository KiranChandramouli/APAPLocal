* @ValidationCode : MjotMTIyOTgxNjQ4ODpDcDEyNTI6MTY4MDc4MzY2ODU4MzpJVFNTOi0xOi0xOjE3NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 174
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.POP.COLL.RIGHT(IN.COLL.ID, IN.POS)

* Subroutine Type : ROUTINE
* Attached to     : Called from REDO.FC.S.COLL.DI
* Attached as     : Routine
* Primary Purpose : Populate COLLATERAL.RIGHT
*
* Incoming:
* ---------
*  IN.COLL.ID: Collateral Id
* IN.POS: Position to assign en R.NEW
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Víctor Panchi - TAM Latin America
* Date            : 14 Dic 2011
*
* Edited by       : Jorge Valarezo - TAM Latin America
* Date            : 11 Apr 2012
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL.RIGHT

    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS.MAIN

RETURN  ;* Program RETURN

*------------------------
INITIALISE:
*=========
    R.COLLATERAL.RIGHT   = ''
    Y.COLL.RIGHT.ID  = IN.COLL.ID[".",1,1] : "." : IN.COLL.ID[".",2,1]
    Y.ERR = ''
    Y.COLL.RIGHT.ERR  = ''

RETURN

*------------------------
OPEN.FILES:
*=========
    FN.COLLATERAL.RIGHT = 'F.COLLATERAL.RIGHT'
    F.COLLATERAL.RIGHT  = ''
    CALL OPF(FN.COLLATERAL.RIGHT, F.COLLATERAL.RIGHT)

RETURN

*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============
    CALL F.READ(FN.COLLATERAL.RIGHT,Y.COLL.RIGHT.ID,R.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT,Y.COLL.RIGHT.ERR)

    IF R.COLLATERAL.RIGHT THEN
        R.NEW(REDO.FC.ID.COLLATERL.RIGHT)<1,IN.POS> = Y.COLL.RIGHT.ID

*LIM.REF es MULTIVALUE
        Y.COMPANY.LIST =  R.COLLATERAL.RIGHT<COLL.RIGHT.COMPANY>
        Y.COMPANY.POS = ''
        Y.I = 1

        LOOP
            REMOVE Y.COMPANY.ID FROM Y.COMPANY.LIST SETTING Y.COMPANY.POS
        WHILE Y.COMPANY.ID:Y.COMPANY.POS

            R.NEW(REDO.FC.COLL.RIGHT.CODE)<1,IN.POS> = R.COLLATERAL.RIGHT<COLL.RIGHT.COLLATERAL.CODE>
*JV11042012 set correct format for Limit Refence
            Y.ID.LIMIT.REF = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE, Y.I>[".",2,1]
            Y.ID.LIMIT.SEC = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE, Y.I>[".",3,1]
            Y.ID.LIMIT.REF = DROUND(Y.ID.LIMIT.REF)
*JV11042012
            R.NEW(REDO.FC.LIMIT.REFERENCE)<1,IN.POS,Y.I> = Y.ID.LIMIT.REF:".":Y.ID.LIMIT.SEC
            R.NEW(REDO.FC.VALIDITY.DATE)<1,IN.POS> = R.COLLATERAL.RIGHT<COLL.RIGHT.VALIDITY.DATE>
            R.NEW(REDO.FC.SEC.HOLD.IDENTIF)<1,IN.POS> = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REF.CUST, Y.I>
            Y.I += 1
        REPEAT
    END ELSE
        AF = REDO.FC.ID.COLLATERL.RIGHT
        AV = IN.POS
        ETEXT = "EB-&.RECORD.NOT.FOUND.&"
        ETEXT<-1> = Y.COLL.RIGHT.ID : @VM : "COLLATERAL.RIGHT"
        CALL STORE.END.ERROR      ;*Se llama a la function STORE.END.ERROR
    END

RETURN

END
