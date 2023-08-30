* @ValidationCode : MjoxNDY0Njg5NjkzOkNwMTI1MjoxNjgwNjA1OTQyNzYzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:29:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE INTERFACE.CONF.INPUT
* ======================================================
*
* ======================================================
* CREATED:INTERFACE TEAM
* ------------------------------------------------------
* Description
* ===========
* This routine is added as a validation routine in the version
* and to call callj to encrypt the value
*
* ------------------------------------------------------
* History
* ------------------------------------------------------
* ODR No:
* Date: JUNE 24 2011
* Name:jeyasubbiah@temenos.com
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM,FM TO @FM
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION            NOCHANGE
* ------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.INTERFACE.CONFIG.PRT
    $INSERT JBC.h

*---------------
INIT:
*---------------
    INT.MAIN.ENC = R.NEW(INTRF.MSG.INT.MAIN.ENC)
    INT.SUB.ENC =   R.NEW(INTRF.MSG.INT.SUB.ENC)
    TXN.CNT = DCOUNT(R.NEW(INTRF.MSG.INT.FLD.NAME),@VM) ;*AUTO R22 CODE CONVERSION

    GOSUB CHECK.EMPTY
RETURN

*---------------
CHECK.EMPTY:
*---------------

    CNT = '1'
    LOOP
        WHILE(CNT LE TXN.CNT)
        INTF.FLD.NAME = R.NEW(INTRF.MSG.INT.FLD.NAME)<1,CNT>

        INTF.ENCT = R.NEW(INTRF.MSG.INT.ENCRY)<1,CNT>

        IF INTF.FLD.NAME EQ "" THEN
            ETEXT = "EB-INTF.ERR.VLD"
            CALL STORE.END.ERROR
            RETURN
        END

        CNT+=1

    REPEAT
    GOSUB STRING.MAPPING
RETURN
*---------------
STRING.MAPPING:
*---------------

    INTERFACE.ID = ID.NEW
    INTERFACE.STRING = ''

    CNT = '1'
    LOOP
        WHILE(CNT LE TXN.CNT)
        INTF.FLD.NAME = R.NEW(INTRF.MSG.INT.FLD.NAME)<1,CNT>
        INTF.FLD.VALUE = R.NEW(INTRF.MSG.INT.FLD.VAL)<1,CNT>
        INTF.ENCT = R.NEW(INTRF.MSG.INT.ENCRY)<1,CNT>
        INTERFACE.STRING = INTERFACE.STRING : INT.MAIN.ENC : INTF.FLD.NAME : INT.SUB.ENC : INTF.FLD.VALUE : INT.SUB.ENC : INTF.ENCT
        CNT+=1
    REPEAT
    INTERFACE.STRING = INTERFACE.ID : INTERFACE.STRING
    GOSUB CALLJEE.PROCESS

RETURN
*---------------
CALLJEE.PROCESS:
*--------------

    INPUT_PARAM = INTERFACE.STRING
    ACTIVATION = "TEMENOS_PROPERTIES_UTILITY"
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)

    IF ERROR.CODE THEN
        ETEXT = "EB-JAVACOMP":@FM:ERROR.CODE ;*AUTO R22 CODE CONVERSION
        CALL STORE.END.ERROR
        RETURN
    END

    GOSUB UPD.ENCRP

RETURN

*---------------
UPD.ENCRP:
*---------------
    ENCRP.VAL = INPUT_PARAM
    ENCRP.VAL.CNT = DCOUNT(ENCRP.VAL,INT.SUB.ENC)
    CNT.ENRY = 1

    LOOP
        WHILE(CNT.ENRY LE ENCRP.VAL.CNT)
        R.NEW(INTRF.MSG.INT.FLD.VAL)<1,CNT.ENRY> = FIELD(ENCRP.VAL,INT.SUB.ENC,CNT.ENRY)
        CNT.ENRY+=1
    REPEAT


RETURN
END
