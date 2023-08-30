* @ValidationCode : MjotMTE5NTYzMjgzOkNwMTI1MjoxNjgxNzk0MDc2MDk4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:31:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.TYPE.CUSTOMER(ENQ.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This build routine is used to fetch the records based on "TIPO.DE.PERSONA" selection fields

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 23-03-11          Sudharsanan S   PACS00036502        Initial Creation
* 16-04-11          sudharsanan S   PACS00033264       Modify the logic based on selection fields
* 30-05-11          Manju.G         PACS00036502        Initial Creation
* Date                   who                   Reference              
* 18-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 18-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION

    GOSUB OPENFILES
RETURN
**********
OPENFILES:
*********

    APPLICATION.NAME = 'REDO.RESTRICTIVE.LIST'
    CALL GET.STANDARD.SELECTION.DETS(APPLICATION.NAME,OUT.REC)
    LOCATE 'TIPO.DE.PERSONA' IN OUT.REC<SSL.SYS.FIELD.NAME, 1> SETTING SS.POS THEN
        PERSONA.VALUE = OUT.REC<SSL.SYS.VAL.PROG,SS.POS>
        FISICA.VALUE = FIELD(PERSONA.VALUE,'&',2)
        FISICA.VALUE=FIELD(FISICA.VALUE,'_',1)
        JURIDICA.VALUE = FIELD(PERSONA.VALUE,'_',2)
    END
*PACS00036502 -S

    LOCATE 'LISTA.RESTRICTIVA' IN OUT.REC<SSL.SYS.FIELD.NAME, 1> SETTING LISTA.POS THEN
        VAR.VIRTUAL.TABLE = 'LIST'
        CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
        CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
        VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>      ;*2nd Part of @ID
        VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>    ;*Description field values
        CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
        CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS

*POLICIA.FIRST.VALUE = OUT.REC<SSL.SYS.VAL.PROG,LISTA.POS>
*POLICIA.SECOND.VALUE =FIELD(POLICIA.FIRST.VALUE,'&',2)
*POLICIA.VALUE = FIELD(POLICIA.SECOND.VALUE,'_',1)
*CLIENTE.VALUE = FIELD(POLICIA.SECOND.VALUE,'_',6)

    END
*PACS00036502-E
    TOT.ENQ.VAL = DCOUNT(ENQ.DATA<4>,@VM)
*PACS00033264 - S
    IF TOT.ENQ.VAL GE '1' THEN
        FOR DATA.VALUE=1 TO TOT.ENQ.VAL
            FINDSTR 'FISICA' IN ENQ.DATA<4,DATA.VALUE> SETTING ENQ.DATA.POS1 THEN
                FINDSTR 'JURIDICA' IN ENQ.DATA<4,DATA.VALUE> SETTING ENQ.DATA.POS2 THEN

                    ENQ.DATA<4,DATA.VALUE> = JURIDICA.VALUE
                END ELSE
                    ENQ.DATA<4,DATA.VALUE>=FISICA.VALUE

                END
            END

            FINDSTR 'POLICIA' IN ENQ.DATA<4,DATA.VALUE> SETTING POLICIA.POS THEN

                FINDSTR 'POLICIA' IN VIRTUAL.TABLE.VALUES SETTING POLICIA.POS1 THEN
*FINAL.POLICIA.VALUE=POLICIA.VALUE
                    FINAL.POLICIA.VALUE = VIRTUAL.TABLE.IDS<POLICIA.POS1>
                    ENQ.DATA<4,DATA.VALUE>=FINAL.POLICIA.VALUE
                END
            END
            FINDSTR 'DESEADO' IN ENQ.DATA<4,DATA.VALUE> SETTING CLIENTE.POS THEN
                FINDSTR 'DESEADO' IN VIRTUAL.TABLE.VALUES SETTING CLIENTE.POS1 THEN
                    FINAL.CLIENTE.VALUE = VIRTUAL.TABLE.IDS<CLIENTE.POS1>
*FINAL.CLIENTE.VALUE=CLIENTE.VALUE
                    ENQ.DATA<4,DATA.VALUE> = FINAL.CLIENTE.VALUE
                END
            END
            ENQ.DATA<4,DATA.VALUE>='"':ENQ.DATA<4,DATA.VALUE>:'"'
        NEXT DATA.VALUE
    END ELSE
        FINDSTR 'FISICA' IN ENQ.DATA<4,DATA.VALUE> SETTING ENQ.DATA.POS1 THEN
            FINDSTR 'JURIDICA' IN ENQ.DATA<4,DATA.VALUE> SETTING ENQ.DATA.POS2 THEN
                ENQ.DATA<4,DATA.VALUE> = JURIDICA.VALUE
            END ELSE
                ENQ.DATA<4,DATA.VALUE>=FISICA.VALUE
            END
        END

*FINDSTR 'NACIONAL' IN ENQ.DATA<4,DATA.VALUE> SETTING NACIONAL.POS THEN
*ENQ.DATA<4,DATA.VALUE>=POLICIA.VALUE
*END
*FINDSTR 'DESEADO' IN ENQ.DATA<4,DATA.VALUE> SETTING DESEADO.POS THEN
*ENQ.DATA<4,DATA.VALUE>=CLIENTE.VALUE
*END

        ENQ.DATA<4,1> = '"':ENQ.DATA<4>:'"'
    END
*PACS00033264 - E
RETURN
*-----------------------------------------------------------------------------------------
END
