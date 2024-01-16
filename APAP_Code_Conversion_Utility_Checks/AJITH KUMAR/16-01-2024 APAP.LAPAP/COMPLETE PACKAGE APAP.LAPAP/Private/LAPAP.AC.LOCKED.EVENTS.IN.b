* @ValidationCode : MjoxMzkyNjM1MDQ0OkNwMTI1MjoxNjgyMzM1OTQ1NjQzOklUU1M6LTE6LTE6MTc5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 179
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AC.LOCKED.EVENTS.IN
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT ;* AUTO R22 CODE CONVERSION END
   $USING EB.LocalReferences
    GOSUB MAIN.PROCESS
RETURN
*------------
MAIN.PROCESS:
*------------
    Y.ACCOUNT.NUMBER = ""
    Y.CUSTOMER = ""
    Y.CATEGORIA = ''
    Y.ACCOUNT.NUMBER =  COMI
    GOSUB LAPAP.GET.AC.CLIENTE
    GOSUB LAPAP.CUENTA.AC.VALIDA
*-------------------
LAPAP.GET.AC.CLIENTE:
*-------------------
    Y.AA.ARR.ID = Y.ACCOUNT.NUMBER
    FN.AC = "F.ACCOUNT"
    FV.AC = ""
    CALL OPF (FN.AC, FV.AC)
    AC.ERROR = ''
    A.AC = ''
    R.AC = ''
    CALL F.READ(FN.AC,Y.AA.ARR.ID,R.AC,FV.AC, AC.ERROR)
    Y.CUSTOMER = R.AC<AC.CUSTOMER>
    Y.CATEGORIA = R.AC<AC.CATEGORY>
*    CALL GET.LOC.REF("AC.LOCKED.EVENTS", "L.AC.CUSTOMER",Y.L.AC.CUSTOMER.POS)
EB.LocalReferences.GetLocRef("AC.LOCKED.EVENTS", "L.AC.CUSTOMER",Y.L.AC.CUSTOMER.POS);* R22 UTILITY AUTO CONVERSION
    R.NEW(AC.LCK.LOCAL.REF)<1,Y.L.AC.CUSTOMER.POS> = Y.CUSTOMER
RETURN
*--------------------
LAPAP.CUENTA.AC.VALIDA:
*--------------------
    IF Y.CATEGORIA GE 3000 AND Y.CATEGORIA LE 3999 THEN
        MESSAGE = "NO SE PUEDEN BLOQUEAR PRESTAMO."
        E = MESSAGE
        ETEXT = E
        CALL ERR
    END
END
