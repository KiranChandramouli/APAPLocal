* @ValidationCode : MjotMTA5NTQ1NTExMTpDcDEyNTI6MTY4NjY3NDI2NTk4NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TELLER.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.TELLER.AUTORTN
* ODR NO      : ODR-2009-10-0322
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.PROCESS to
* default the value for the TELLER application from REDO.TELLER.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO             REFERENCE          DESCRIPTION
* 15.05.2010  S SUDHARSANAN      ODR-2009-10-0322   INITIAL CREATION
* 19/04/2013  Vignesh Kumaar R   PACS00266545       Field values not getting defaulted from REDO.TELLER.PROCESS application
*14/12/2022                                         Based on REDO.TELLER.AUTORTN
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*12/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION       INSERT FILE MODIFIED, VM TO @VM
*12/06/2023      SURESH                     MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.TELLER ;*AUTO R22 CODE CONVERSION - END


    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TELLER.PROCESS = 'F.REDO.TELLER.PROCESS'
    F.REDO.TELLER.PROCESS = ''
    CALL OPF(FN.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS)


    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.TT.PROCESS':@VM:'L.COMMENTS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.PROCESS=LOC.REF.POS<1,1>
    POS.L.COMMENTS = LOC.REF.POS<1,2>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)

* Fix for PACS00266545 [Field values not getting defaulted from REDO.TELLER.PROCESS application]

    LOOP
        REMOVE Y.DATA.VAL FROM Y.DATA SETTING Y.DATA.POS
    WHILE Y.DATA.VAL:Y.DATA.POS
        CHECK.TT.ID.CONDITION = FIELD(Y.DATA.VAL,'*',1)
        IF CHECK.TT.ID.CONDITION EQ 'CURRENT.ID' THEN
            Y.REDO.TELLER.PROCESS.ID=FIELD(Y.DATA.VAL,"*",2)
            EXIT
        END
    REPEAT

* End of Fix


    CALL F.READ(FN.REDO.TELLER.PROCESS,Y.REDO.TELLER.PROCESS.ID,R.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS,PRO.ERR)

    Y.CURRENCY = R.REDO.TELLER.PROCESS<TEL.PRO.CURRENCY>
    Y.AMOUNT =R.REDO.TELLER.PROCESS<TEL.PRO.AMOUNT>
    Y.CATEGORY = R.REDO.TELLER.PROCESS<TEL.PRO.CATEGORY>

    Y.CONCEPT =R.REDO.TELLER.PROCESS<TEL.PRO.CONCEPT>
    R.NEW(TT.TE.CURRENCY.1)=Y.CURRENCY
    IF Y.CURRENCY NE LCCY THEN
        R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> = Y.AMOUNT
    END ELSE
        R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>=Y.AMOUNT
        R.NEW(TT.TE.AMOUNT.LOCAL.2)=Y.AMOUNT
    END


    R.NEW(TT.TE.NARRATIVE.1) = Y.CONCEPT

    IF Y.CONCEPT EQ 'PASO RAPIDO' OR Y.CONCEPT EQ 'KIT PASO RAPIDO' OR Y.CONCEPT EQ 'KIT PASO RAPIDO PIGGY'  THEN
        R.NEW(TT.TE.ACCOUNT.1) = 'DOP1763600010017'
    END ELSE
        R.NEW(TT.TE.ACCOUNT.1) = 'PL':Y.CATEGORY
    END

*R.NEW(TT.TE.ACCOUNT.1) = 'PL':Y.CATEGORY

    R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.PROCESS>=Y.REDO.TELLER.PROCESS.ID
RETURN

END
