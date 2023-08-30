* @ValidationCode : Mjo4MzExNDI3MjE6Q3AxMjUyOjE2ODEyMDY2MjIwNDY6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:20:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHK.YIELD
*-----------------------------------------------------------------------------------------------
* Company Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by    : Temenos Application Management
* Program Name    : REDO.V.INP.CHK.YIELD
*-----------------------------------------------------------------------------------------------
* Description   : This is the Validation routine for the field SECURITY.CODE in SEC.TRADE
*                 & for PRICE.TYPE field in SECURITY.MASTER tables which will allow the local
*                 reference field to input only if CALCULATION.METHOD of PRICE.TYPE is PRICE/DPRICE
*
* In  Parameter : --na--
* Out Parameter : --na--
* ODR Number    : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 25.07.2011      Pradeep S         PACS00091606    Error message used for mandartory yield input
*-------------------------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.PRICE.TYPE

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----
INIT:
*----
*Initialising and opening necesseary Variables
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    R.SECURITY.MASTER = ''
    Y.SM.ERR = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.PRICE.TYPE = 'F.PRICE.TYPE'
    F.PRICE.TYPE = ''
    R.PRICE.TYPE = ''
    Y.PT.ERR = ''
    CALL OPF(FN.PRICE.TYPE,F.PRICE.TYPE)

    LOC.REF.APPLICATION = "SECURITY.MASTER":@FM:"SEC.TRADE"
    LOC.REF.FIELDS = "L.SC.TRN.YIELD":@FM:"L.SC.TRN.YIELD":@VM:"L.NUM.OP.CEN"
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    Y.SM.TRN.POS = LOC.REF.POS<1,1>
    Y.ST.TRN.POS = LOC.REF.POS<2,1>
    WPOSL1 = LOC.REF.POS<2,2>

*****************
    IF NOT( R.OLD(SC.SBS.CURR.NO) ) THEN
        T.LOCREF<WPOSL1, 7> = 'NOINPUT'
    END ELSE
        T.LOCREF<WPOSL1, 7> = ''
    END
*****************

*CALL GET.LOC.REF('SECURITY.MASTER','L.SC.TRN.YIELD',Y.SM.TRN.POS)
*CALL GET.LOC.REF('SEC.TRADE','L.SC.TRN.YIELD',Y.ST.TRN.POS)

RETURN

*-------
PROCESS:
*-------
*Updating the Local reference field status to 'NOINPUT'
    Y.APPL = APPLICATION
    BEGIN CASE
        CASE Y.APPL EQ "SEC.TRADE"
            Y.SEC.NO = R.NEW(SC.SBS.SECURITY.CODE)
            CALL F.READ(FN.SECURITY.MASTER,Y.SEC.NO,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.SM.ERR)
            IF R.SECURITY.MASTER NE '' THEN
                Y.PRICE.TYPE = R.SECURITY.MASTER<SC.SCM.PRICE.TYPE>
                Y.LAST.PRICE = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
                IF R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE> EQ 'S' THEN
                    GOSUB MAKE.NOINPUT
                    RETURN
                END
            END
            Y.ST.YIELD = R.NEW(SC.SBS.LOCAL.REF)<1,Y.ST.TRN.POS>
        CASE Y.APPL EQ "SECURITY.MASTER"
            Y.PRICE.TYPE = R.NEW(SC.SCM.PRICE.TYPE)
            Y.SM.YIELD = R.NEW(SC.SCM.LOCAL.REF)<1,Y.SM.TRN.POS>
            IF R.NEW(SC.SCM.BOND.OR.SHARE) EQ 'S' THEN
                GOSUB MAKE.NOINPUT
                RETURN
            END
    END CASE

    CALL CACHE.READ(FN.PRICE.TYPE, Y.PRICE.TYPE, R.PRICE.TYPE, Y.PT.ERR)   ;*R22 AUTO CODE CONVERSION
    IF R.PRICE.TYPE NE '' THEN
        Y.CALC.METHOD = R.PRICE.TYPE<SC.PRT.CALCULATION.METHOD>
        GOSUB SUB.PROCESS
    END
RETURN

*--------------------------------------------------------------------------------------------------
SUB.PROCESS:
*-----------
*PACS00052348 - New section

    IF Y.CALC.METHOD NE 'PRICE' THEN
        IF Y.CALC.METHOD NE 'DPRICE' THEN
            GOSUB MAKE.NOINPUT
        END ELSE
            GOSUB MAKE.MAND
        END
    END ELSE
        GOSUB MAKE.MAND
    END

RETURN


*--------------------------------------------------------------------------------------------------
MAKE.NOINPUT:
*--------------
*Updating the Status of the field as NOINPUT
    BEGIN CASE
        CASE Y.APPL EQ "SEC.TRADE"
            R.NEW(SC.SBS.LOCAL.REF)<1,Y.ST.TRN.POS> = ''
            T.LOCREF<Y.ST.TRN.POS,7> = 'NOINPUT'
        CASE Y.APPL EQ "SECURITY.MASTER"
            R.NEW(SC.SCM.LOCAL.REF)<1,Y.SM.TRN.POS> = ''
            T.LOCREF<Y.SM.TRN.POS,7> = 'NOINPUT'
    END CASE
RETURN


*--------------------------------------------------------------------------------------------------
MAKE.MAND:
*---------
*Updating the Status of the field as MANDATORY
*PACS00056285 - S/E

    BEGIN CASE
        CASE Y.APPL EQ "SEC.TRADE"
            IF Y.ST.YIELD EQ '' THEN
                T.LOCREF<Y.ST.TRN.POS,7> = ''
                AF = SC.SBS.LOCAL.REF
                AV = Y.ST.TRN.POS
                ETEXT = 'EB-INPUT.MAND'
                CALL STORE.END.ERROR
            END
        CASE Y.APPL EQ "SECURITY.MASTER"
            IF Y.SM.YIELD EQ '' THEN
                T.LOCREF<Y.SM.TRN.POS,7> = ''
                AF = SC.SCM.LOCAL.REF
                AV = Y.SM.TRN.POS
                ETEXT = 'EB-INPUT.MAND'
                CALL STORE.END.ERROR
            END
    END CASE

RETURN

END
